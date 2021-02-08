//
//  AnnotatedMapView.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 17/07/2020.
//

import MapKit
import SwiftUI

struct AnnotatedMapView: View {
    
    @ObservedObject private var locationManager = LocationManager()
    @EnvironmentObject var store: ClubStore
    
    // Default to center on the UK, zoom to show the whole island
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 54.4609,
                                       longitude: -3.0886),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: store.clubs!) {
                    club in MapAnnotation(coordinate: club.coordinate) {
                        ClubAnnotation(annotate: club)
                    }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationBarTitle(Text("Map View"), displayMode: .inline)
        .navigationBarItems(trailing:
                                Button(action: {
                                    withAnimation {
                                        region.center = locationManager.current!.coordinate
                                        region.span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                                    }
                                })
                                    {Image(systemName: "location")}
        )
    }
}

struct AnnotatedMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AnnotatedMapView().environmentObject(ClubStore())
        }
    }
}
