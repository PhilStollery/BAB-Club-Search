//
//  ClubLocation.swift
//  BAB Club Dearch
//
//  Created by Phil Stollery on 03/07/2020.
//

import SwiftUI
import MapKit

struct AllClubsView: View {
    
    let locationFetcher = LocationFetcher()
    @ObservedObject var store: ClubStore
    @State private var coordinateRegion: MKCoordinateRegion
    @State private var trackingMode = MapUserTrackingMode.follow
    
    init(store: ClubStore) {
        var myLocation = MKCoordinateRegion()
        
        if let location = self.locationFetcher.lastKnownLocation {
            myLocation = MKCoordinateRegion(center: location, latitudinalMeters: 10000, longitudinalMeters: 10000)
        } else {
            //centre on the middle of the UK
            myLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 54.00366, longitude: -2.547855) , latitudinalMeters: 500000, longitudinalMeters: 500000)
        }
        self.store = store
        self._coordinateRegion = State(wrappedValue: myLocation)
    }
    
    var body: some View {
        
        VStack {
            Map(coordinateRegion: $coordinateRegion,
                showsUserLocation: true, userTrackingMode: $trackingMode,
                annotationItems: store.clubs!) {item in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.lng), tint: .accentColor )
            }
        }
        .navigationBarTitle(Text("Map View"), displayMode: .large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    coordinateRegion = MKCoordinateRegion(center: self.locationFetcher.lastKnownLocation!, latitudinalMeters: 10000, longitudinalMeters: 10000)
                } label: {
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 40))
                        .accessibility(label: Text("Center the map on my location"))
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct Details: View {
    var club: Club
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(club.clubname)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Text(club.town)
                .foregroundColor(.accentColor)
            Text(club.association)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct AllClubs_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                AllClubsView(store: ClubStore())
            }
            NavigationView {
                AllClubsView(store: ClubStore())
            }.preferredColorScheme(.dark)
        }

    }
}
