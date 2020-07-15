//
//  ClubStore.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 04/07/2020.
//

import Foundation
import AEXML

/// Store all the loaded clubs
class ClubStore: ObservableObject {
    @Published var clubs: [Club]? = nil
    @Published var dataLoaded = false
}

extension ClubStore {
    
    /// Let views request for the data to be loaded
    /// - Parameter urlString: The URL to get the club data from, guess it could be in settings
    func loadXML(urlString: String) {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: parseXMLData)
        // go get the data
        task.resume()
    }
    
    
    /// Delegate for the URLSession
    /// - Parameters:
    ///   - data: data returned from the API
    ///   - urlResponse: HTTP reposnse code
    ///   - error: error details from iOS
    func parseXMLData(data: Data?, urlResponse: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error trying to call API: \(error!)")
            return
        }
        
        guard let content = data else {
            print("Error no data returned from API")
            return
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
                    parsedClubs.append(Club(clubId:Int(child.attributes["Id"]!)!,
                      association: child.attributes["association"]!.trimmingCharacters(in: .whitespacesAndNewlines),
                      clubname: child.attributes["clubname"]!.trimmingCharacters(in: .whitespacesAndNewlines),
                      town: child.attributes["clubtown"]!.trimmingCharacters(in: .whitespacesAndNewlines),
                      lat: Double(child.attributes["lat"]!)!, lng: Double(child.attributes["lng"]!)!))
                }
            }
            
            //Updating an observed variable can't be done in the background, so send to main
            DispatchQueue.main.async {
                self.clubs = parsedClubs
                self.dataLoaded = true
            }
        } catch {
            print("Error parsing XML: \(error)")
        }
    }

}
