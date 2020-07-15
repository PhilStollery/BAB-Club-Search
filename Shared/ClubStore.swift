//
//  ClubStore.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 04/07/2020.
//

import Foundation
import AEXML
import MapKit

class ClubStore: ObservableObject {
    @Published var clubs: [Club]
    
    init(clubs: [Club] = []) {
        let semaphore = DispatchSemaphore(value: 0)
        
        self.clubs = clubs
        
        // Call the BAB search API to get XML for every Dojo in the database
        let url = URL(string: "https://www.bab.org.uk/wp-content/plugins/bab-clubs/googlemap/wordpress_clubs_xml.asp?lat=0&lng=0&radius=10&assoc=all&coach=all")!

        let downloadTask = URLSession.shared.downloadTask(with: url) {
            urlOrNil, responseOrNil, errorOrNil in
            // check for and handle errors:
            // * errorOrNil should be nil
            // * responseOrNil should be an HTTPURLResponse with statusCode in 200..<299
            
            guard let fileURL = urlOrNil else {
                self.readXML()
                semaphore.signal()
                return
            }
            do {
                let documentsURL = try
                    FileManager.default.url(for: .documentDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: false)
                let savedURL = documentsURL.appendingPathComponent(fileURL.lastPathComponent)
                try FileManager.default.moveItem(at: fileURL, to: savedURL)
                self.readXML(fileLocation: savedURL)
                semaphore.signal()
            } catch {
                semaphore.signal()
                print ("file error: \(error)")
            }
        }
        downloadTask.resume()
        semaphore.wait()
    }

    private func readXML(fileLocation: URL? = nil) {

        var options = AEXMLOptions()
        options.parserSettings.shouldProcessNamespaces = false
        options.parserSettings.shouldReportNamespacePrefixes = false
        options.parserSettings.shouldResolveExternalEntities = false
        
        var checkLocation = fileLocation
        
        if (checkLocation == nil) {
            let xmlPath = Bundle.main.path(forResource: "clubs", ofType: "xml")
            checkLocation = URL(fileURLWithPath: xmlPath!)
        }
        
        guard
            let data = try? Data(contentsOf: checkLocation!)
        else {
            print("Cannot load the downloaded file")
            return
        }
        
        do {
            let document = try AEXMLDocument(xml: data, options: options)
            
            // parse known structure
            for child in document.root.children {
                
                // people can
                if (child.attributes["lat"]! != "0" && child.attributes["lng"]! != "0") {
                    clubs.append(Club(association: child.attributes["association"]!.trimmingCharacters(in: .whitespacesAndNewlines),
                                      clubname: child.attributes["clubname"]!.trimmingCharacters(in: .whitespacesAndNewlines),
                                      town: child.attributes["clubtown"]!.trimmingCharacters(in: .whitespacesAndNewlines),
                                      lat: Double(child.attributes["lat"]!)!, lng: Double(child.attributes["lng"]!)!))
                }
            }
        } catch {
            print("Error parsing XML: \(error)")
        }
    }

}

let testStore = ClubStore(clubs: testData)
