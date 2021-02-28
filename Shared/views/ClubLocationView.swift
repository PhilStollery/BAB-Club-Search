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
            Spacer(minLength: 30)
            Button(action: {showingDetailScreen = true}) {
                HStack {
                    Text("BAB information")
                    Image(systemName: "arrowshape.turn.up.right.fill")
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(
                    cornerRadius: 8,
                    style: .continuous
                ).stroke(Color.accentColor)
            )
            Text(club.association)
                .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color.secondary)
                .padding(.top)
            Text(club.town)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color.secondary)
                .padding(.bottom)
            Map(coordinateRegion: $coordinateRegion, annotationItems: [club], annotationContent: { (club) in return MapPin(coordinate: CLLocationCoordinate2D(latitude: club.lat, longitude: club.lng), tint: Color.accentColor) } )
                .frame(alignment: .center)
                .shadow(radius: 4, x: 2, y: 2)
                .padding()
        }
        .navigationTitle(Text(club.clubname))
        .navigationBarTitleDisplayMode(.inline)
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
            Button(action: {presentationMode.wrappedValue.dismiss()}) {
                HStack {
                    Text("Close BAB")
                    Image(systemName: "chevron.down")
                }
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
                ClubLocationView(club: testData[3])
            }.preferredColorScheme(.dark)
            NavigationView {
                ClubLocationView(club: testData[4])
            }
        }
    }
}
