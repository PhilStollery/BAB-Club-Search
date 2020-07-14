//
//  Clubs.swift
//  BAB Club Dearch
//
//  Created by Phil Stollery on 03/07/2020.
// Dojo data will be loaded from https://www.bab.org.uk/wp-content/plugins/bab-clubs/googlemap/wordpress_clubs_xml.asp?lat=0&lng=0&radius=10&assoc=all&coach=all
// XML in this format
// <marker Id="822" association="Go Shin Kai" clubname=" Aikido Kami" clubtown="Bourton on the Water" lat="51.885414" lng="-1.759105" c1="3" c2="0" c3="0" ct="0" yp="0" adults="2" family="0" children="1" weapons="0" clubmark="0" distance="0"/>
// <marker Id="38" association="KSMBDA Kolesnikov School" clubname="KSMBDA Bridport" clubtown="Bridport" lat="50.72583" lng="-2.763421" c1="4" c2="2" c3="0" ct="0" yp="6" adults="16" family="0" children="16" weapons="0" clubmark="0" distance="0"/>
// <marker Id="39" association="KSMBDA Kolesnikov School" clubname="KSMBDA Bristol" clubtown="Bristol" lat="51.529461" lng="-2.563554" c1="3" c2="1" c3="0" ct="0" yp="1" adults="0" family="0" children="0" weapons="0" clubmark="0" distance="0"/>
// <marker Id="30" association="KSMBDA Kolesnikov School" clubname="KSMBDA Kendal" clubtown="Kendal" lat="54.338791" lng="-2.73551" c1="1" c2="0" c3="0" ct="0" yp="0" adults="2" family="0" children="0" weapons="0" clubmark="0" distance="0"/>
// <marker Id="31" association="KSMBDA Kolesnikov School" clubname="KSMBDA Swindon" clubtown="Swindon" lat="51.546513" lng="-1.773501" c1="6" c2="4" c3="0" ct="0" yp="4" adults="34" family="0" children="0" weapons="0" clubmark="0" distance="0"/>

import Foundation
import MapKit

struct Club: Identifiable, Hashable {
    static func == (lhs: Club, rhs: Club) -> Bool {
        return lhs.clubname == rhs.clubname && lhs.association == rhs.association
    }
    
    func hasPrefix(search: String) -> Bool {
        return association.lowercased().contains(search.lowercased())
            || clubname.lowercased().contains(search.lowercased())
            || town.lowercased().contains(search.lowercased())
    }
    
    var id = UUID()
    var association: String
    var clubname: String
    var town: String
    var lat: Double
    var lng: Double
}

let testData = [
    Club(association: "Go Shin Kai", clubname: "Aikido Kami", town: "Bourton on the Water", lat: 51.885414, lng: -1.759105),
    Club(association: "KSMBDA Kolesnikov School", clubname: "KSMBDA Bridport", town: "Bridport", lat: 50.72583, lng: -2.763421),
    Club(association: "KSMBDA Kolesnikov School", clubname: "KSMBDA Bristol", town: "Bristol", lat: 51.52946, lng: -2.563554),
         Club(association: "KSMBDA Kolesnikov School", clubname: "KSMBDA Kendal", town: "Kendal", lat: 54.338791, lng: -2.73551),
    Club(association: "KSMBDA Kolesnikov School", clubname: "KSMBDA Swindon", town: "Swindon", lat: 51.546513, lng: -1.773501)
]
