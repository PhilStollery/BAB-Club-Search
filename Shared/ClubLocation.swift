//
//  ClubLocation.swift
//  BAB Club Dearch
//
//  Created by Phil Stollery on 03/07/2020.
//

import SwiftUI
import MapKit



struct ClubLocation: View {
    var club: Club
    @State private var coordinateRegion: MKCoordinateRegion
    
    init(club: Club) {
        let getPoisiton = MKCoordinateRegion(center: club.location, latitudinalMeters: 1500, longitudinalMeters: 1500)
        self._coordinateRegion = State(wrappedValue: getPoisiton)
        self.club = club
    }
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $coordinateRegion, annotationItems: [club], annotationContent: { (club) in return MapPin(coordinate: club.location, tint: Color.accentColor) } )
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
        }
        .navigationTitle(Text(club.clubname))
    }
}

struct ClubLocation_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ClubLocation(club: testData[2])
        }
    }
}
