//
//  ClubStore.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 04/07/2020.
//

import SwiftUI
import AEXML

class ClubStore: ObservableObject {
    @Published var clubs: [Club]? = nil
    @Published var dataLoaded = false
    @Published var totalClubs: Int = 0
    @Published var addedClubs: Int = 0
}

extension ClubStore {
    func loadXML(urlString: String) {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: parseXMLData)
        task.resume()
    }
        
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
            
            DispatchQueue.main.async {
                self.totalClubs = document.root.children.count
            }
            
            // parse known structure
            for child in document.root.children {
                
                // people can
                if (child.attributes["lat"]! != "0" && child.attributes["lng"]! != "0") {
                    parsedClubs.append(Club(clubId:Int(child.attributes["Id"]!)!,
                      association: child.attributes["association"]!.trimmingCharacters(in: .whitespacesAndNewlines),
                      clubname: child.attributes["clubname"]!.trimmingCharacters(in: .whitespacesAndNewlines),
                      town: child.attributes["clubtown"]!.trimmingCharacters(in: .whitespacesAndNewlines),
                      lat: Double(child.attributes["lat"]!)!, lng: Double(child.attributes["lng"]!)!))
                    
                    DispatchQueue.main.async {
                        self.addedClubs += 1
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.clubs = parsedClubs
                self.dataLoaded = true
            }
        } catch {
            print("Error parsing XML: \(error)")
        }
    }

}
