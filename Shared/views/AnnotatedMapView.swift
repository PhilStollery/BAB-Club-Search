//
//  AnnotatedMapView.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 17/07/2020.
//

import MapKit
import SwiftUI

fileprivate let locationFetcher = LocationFetcher()

struct AnnotatedMapView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [MKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var showingDetailScreen = false
    @State private var selectedClub: Club?
    @ObservedObject var store: ClubStore
    
    /// Create the array of club details to add to the map
    func addClubs() {
        for club in self.store.clubs! {
            let newClub = MKPointAnnotation()
            newClub.title = club.clubname
            newClub.subtitle = "\(club.association) (\(club.town))"
            newClub.coordinate = CLLocationCoordinate2D(latitude: club.lat, longitude: club.lng)
            self.locations.append(newClub)
        }
    }
    
    var body: some View {
        ZStack {
            MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: $locations)
                .edgesIgnoringSafeArea(.bottom)
        }
        .navigationBarTitle(Text("Map View"), displayMode: .inline)
        .alert(isPresented: $showingPlaceDetails) {
            Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information."), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Details")) {
                selectedClub = (store.clubs?.first(where: { $0.clubname == selectedPlace?.title }))!
                showingDetailScreen = true
            })
        }
        .sheet(isPresented: $showingDetailScreen, content: {
            SwiftUIWebView(viewURL: URL(string: "https://www.bab.org.uk/clubs/club-search/?ViewClubMapID=\(selectedClub!.clubId)")!)
        })
        .navigationBarItems(trailing:
                                Button(action: {
                                    if let userLocation = locationFetcher.lastKnownLocation {
                                        self.centerCoordinate = userLocation
                                    }
                                })
                                    {Image(systemName: "location")}
        )
        .onAppear {
            addClubs()
            locationFetcher.start()
        }
    }
}

struct AnnotatedMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AnnotatedMapView(store: ClubStore())
        }
    }
}
