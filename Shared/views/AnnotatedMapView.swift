//
//  AnnotatedMapView.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 17/07/2020.
//

import MapKit
import SwiftUI

struct AnnotatedMapView: View {
    
    @ObservedObject
    private var locationManager = LocationManager()
    
    // Default to center on the UK, zoom to show the whole island
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 54.4609,
                                       longitude: -3.0886),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    
    @ObservedObject var store: ClubStore
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: store.clubs!) {
                    club in
                    MapAnnotation(
                        coordinate: club.coordinate
                    ) {
                        VStack{
                            Image(systemName: "mappin")
                                .font(.title)
                                .foregroundColor(.accentColor)
                                .onTapGesture {
                                    let index: Int = store.clubs!.firstIndex(where: {$0.id == club.id})!
                                    store.clubs![index].show.toggle()
                                }
                            if club.show {
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(Color.white)
                                    VStack{
                                        Text(club.clubname)
                                            .padding(.top)
                                        Text(club.association)
                                            .padding(.leading)
                                            .padding(.trailing)
                                        Text(club.town)
                                            .padding(.bottom)
                                    }
                                }
                                .onTapGesture {
                                    let index: Int = store.clubs!.firstIndex(where: {$0.id == club.id})!
                                    store.clubs![index].show = false
                                }
                            }
                        }
                    }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationBarTitle(Text("Map View"), displayMode: .inline)
        .navigationBarItems(trailing:
                                Button(action: {
                                    withAnimation {
                                        self.region.center = locationManager.current!.coordinate
                                        self.region.span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                                    }
                                })
                                    {Image(systemName: "location")}
        )
    }
}

struct AnnotatedMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AnnotatedMapView(store: ClubStore())
        }
    }
}
