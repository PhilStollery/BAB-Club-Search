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
        self.clubs = clubs
        readXML()
    }

    private func readXML() {

        var options = AEXMLOptions()
        options.parserSettings.shouldProcessNamespaces = false
        options.parserSettings.shouldReportNamespacePrefixes = false
        options.parserSettings.shouldResolveExternalEntities = false
        
        guard let
            xmlPath = Bundle.main.path(forResource: "clubs", ofType: "xml"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: xmlPath))
        else {
            print("Cannot load the clubs.xml file")
            return
        }
        
        do {
            let document = try AEXMLDocument(xml: data, options: options)
            
            // parse known structure
            for child in document.root.children {
                clubs.append(Club(association: child.attributes["association"]!, clubname: child.attributes["clubname"]!, town: child.attributes["clubtown"]!, lat: Double(child.attributes["lat"]!)!, lng: Double(child.attributes["lng"]!)!))
            }
        } catch {
            print("Error parsing XML: \(error)")
        }
    }

}



let testStore = ClubStore(clubs: testData)
