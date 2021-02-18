//
//  ClubLocation.swift
//  BAB Club Search
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
            
            Button(action: {showingDetailScreen = true}) {
                Text("BAB information")
            }
            .padding([.top, .leading, .trailing])
            Text(club.association)
                .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color.secondary)
                .padding(.top)
            Text(club.town)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.secondary)
                .padding(.bottom)
        }
        .navigationTitle(Text(club.clubname))
        .sheet(isPresented: $showingDetailScreen, content: {
            DetailView(clubID: club.clubId)
        })
    }
}

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var clubID: Int

    var body: some View {
        VStack{
            Button("Close BAB") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding([.top, .leading, .trailing])
            UrlWebView(urlToDisplay: URL(string: "https://www.bab.org.uk/clubs/club-search/?ViewClubMapID=\(clubID)#example")!)
        }
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
