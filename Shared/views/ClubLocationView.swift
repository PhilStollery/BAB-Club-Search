//
//  ClubLocation.swift
//  BAB Club Dearch
//
//  Created by Phil Stollery on 03/07/2020.
//

import SwiftUI
import MapKit

struct ClubLocationView: View {
    var club: Club
    @State private var coordinateRegion: MKCoordinateRegion
    @State private var showingDetailScreen = false
    
    init(club: Club) {
        let getPoisiton = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: club.lat, longitude: club.lng), latitudinalMeters: 1500, longitudinalMeters: 1500)
        self._coordinateRegion = State(wrappedValue: getPoisiton)
        self.club = club
    }
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $coordinateRegion, annotationItems: [club], annotationContent: { (club) in return MapPin(coordinate: CLLocationCoordinate2D(latitude: club.lat, longitude: club.lng), tint: Color.accentColor) } )
                .frame(alignment: .center)
                .shadow(radius: 2)

            Text(club.association)
                .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color.secondary)
                .padding(.top)
            Text(club.town)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.secondary)
                .padding(.bottom)
            Button(action: {showingDetailScreen = true}) {
                Text("BAB information")
            }
        }
        .navigationTitle(Text(club.clubname))
        .sheet(isPresented: $showingDetailScreen, content: {
            SwiftUIWebView(viewURL: URL(string: "https://www.bab.org.uk/clubs/club-search/?ViewClubMapID=\(club.clubId)")!)
        })
    }
}

struct ClubLocation_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ClubLocationView(club: testData[2])
            }
            NavigationView {
                ClubLocationView(club: testData[2])
            }.preferredColorScheme(.dark)
        }
    }
}
