//
//  ClubStore.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 04/07/2020.
//

import Foundation
import AEXML
import MapKit

/// Store all the loaded clubs
@MainActor
final class ClubStore: ObservableObject {
    @Published var clubs = [Club]()
    @Published var dataLoaded = false
    @Published var mapRect = MKMapRect() // box containing all the dojos
    
    // Find a rectangle that fits all the dojos inside
    func fit() {
        let points = clubs.map(\.coordinate).map(MKMapPoint.init)
        mapRect = points.reduce(MKMapRect.null) { rect, point in
            let newRect = MKMapRect(origin: point, size: MKMapSize())
            return rect.union(newRect)
        }
    }
    
    enum ParsingError: Error {
        case badResponse
        case badXML
    }
    
    // Updates the apps stored Aikido clubs from the BAB website
    func updateClubs() async {
        self.dataLoaded = false
        do {
            let updates = try await fetchClubs()
            clubs = updates
            fit() // now that we've loaded the dojos fit the map rectanlge to it
            self.dataLoaded = true
        } catch {
            clubs = []
        }
    }
    
    func fetchClubs() async throws -> [Club] {
        let requestUrl = URL(string:"https://www.bab.org.uk/wp-content/plugins/bab-clubs/googlemap/wordpress_clubs_xml.asp?lat=0&lng=0&radius=10&assoc=all&coach=all")
        let (xmlClubs, response) = try await URLSession.shared.data(from: requestUrl!)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw ParsingError.badResponse
        }
        guard let results = await parseXMLData(data: xmlClubs) else {
            throw ParsingError.badXML
        }
        return results
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func parseXMLData(data: Data?) async -> [Club]? {
        var content = Data()
        let checkLocation = getDocumentsDirectory().appendingPathComponent("clubs.xml")
        let userSettings = UserSettings()
        
        // read the cached version if fetching the XML data failed
        if data != nil {
            content = data!
        }
        else {
            content = try! Data(contentsOf: checkLocation)
        }
        
        var options = AEXMLOptions()
        options.parserSettings.shouldProcessNamespaces = false
        options.parserSettings.shouldReportNamespacePrefixes = false
        options.parserSettings.shouldResolveExternalEntities = false
        
        do {
            let document = try AEXMLDocument(xml: content, options: options)
            var parsedClubs: [Club] = []
            
            // parse found structure
            for child in document.root.children {
                
                // create clubs for each XML node
                if (child.attributes["lat"]! != "0" && child.attributes["lng"]! != "0") {
                    let fave: Bool = userSettings.favs.firstIndex(where: { $0 == Int(child.attributes["Id"]!)!}) != nil
                    
                    parsedClubs.append(Club(clubId:Int(child.attributes["Id"]!)!,
                      association: child.attributes["association"]!.trimmingCharacters(in: .whitespacesAndNewlines),
                      clubname: child.attributes["clubname"]!.trimmingCharacters(in: .whitespacesAndNewlines),
                      town: child.attributes["clubtown"]!.trimmingCharacters(in: .whitespacesAndNewlines),
                      lat: Double(child.attributes["lat"]!)!, lng: Double(child.attributes["lng"]!)!, fav: fave))
                }
            }
            // Save cached data for when dojos can't be read from API
            do {
                try content.write(to: checkLocation)
            } catch {
                print("Failed updating local cache or clubs.xml, Error: " + error.localizedDescription)
            }
            return parsedClubs
        } catch {
            print("Error parsing XML: \(error)")
            return nil
        }
    }

}
