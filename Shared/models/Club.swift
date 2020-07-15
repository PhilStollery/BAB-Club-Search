//
//  Clubs.swift
//  BAB Club Dearch
//
//  Created by Phil Stollery on 03/07/2020.
// Dojo data will be loaded from https://www.bab.org.uk/wp-content/plugins/bab-clubs/googlemap/wordpress_clubs_xml.asp?lat=0&lng=0&radius=10&assoc=all&coach=all
// XML can be seen in the clubs.xml file
// Clud details - like web address and contact details are in https://www.bab.org.uk/clubs/club-search/?ViewClubMapID= <clubId>

import SwiftUI
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
    var clubId: Int
    var association: String
    var clubname: String
    var town: String
    var lat: Double
    var lng: Double
}

let testData = [
    Club(clubId: 1, association: "Go Shin Kai", clubname: "Aikido Kami", town: "Bourton on the Water", lat: 51.885414, lng: -1.759105),
    Club(clubId: 2, association: "KSMBDA Kolesnikov School", clubname: "KSMBDA Bridport", town: "Bridport", lat: 50.72583, lng: -2.763421),
    Club(clubId: 3, association: "KSMBDA Kolesnikov School", clubname: "KSMBDA Bristol", town: "Bristol", lat: 51.52946, lng: -2.563554),
    Club(clubId: 4, association: "KSMBDA Kolesnikov School", clubname: "KSMBDA Kendal", town: "Kendal", lat: 54.338791, lng: -2.73551),
    Club(clubId: 5, association: "KSMBDA Kolesnikov School", clubname: "KSMBDA Swindon", town: "Swindon", lat: 51.546513, lng: -1.773501)
]
