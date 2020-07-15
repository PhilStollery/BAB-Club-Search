//
//  ClubLocation.swift
//  BAB Club Dearch
//
//  Created by Phil Stollery on 03/07/2020.
//

import SwiftUI
import MapKit

struct AllClubs: View {
    
    let locationFetcher = LocationFetcher()
    var store: ClubStore
    @State private var coordinateRegion: MKCoordinateRegion
    
    init(store: ClubStore) {
        var myLocation = MKCoordinateRegion()
        
        //get users location
        if (locationFetcher.lastKnownLocation != nil){
            myLocation = MKCoordinateRegion(center: locationFetcher.lastKnownLocation!, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
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
                annotationItems: store.clubs) {item in
                MapPin(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.lng) )
            }
        }
        .navigationBarTitle(Text("Map View"), displayMode: .inline)
    }
    
}

struct AllClubs_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllClubs(store: ClubStore())
        }
    }
}
