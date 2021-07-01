//
//  AnnotatedMapView.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 17/07/2020.
//

import MapKit
import SwiftUI
import PartialSheet

struct AnnotatedMapView: View {
    
    @ObservedObject private var locationManager = LocationManager()
    @EnvironmentObject var store: ClubStore
    @EnvironmentObject var partialSheetManager : PartialSheetManager
    @State private var showingSheet = false
    
    // Default to center on the UK, zoom to show the whole island
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 54.4609,
                                       longitude: -3.0886),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: self.store.clubs) {
                club in MapAnnotation(coordinate: club.coordinate) {
                    Image(systemName: "house.circle")
                        .font(.title)
                        .foregroundColor(club.show ? Color.primary : club.fav ? Color.yellow : Color.accentColor)
                        .animation(.easeInOut)
                        .onTapGesture{
                            let index: Int = store.clubs.firstIndex(where: {$0.id == club.id})!
                            self.store.clubs[index].show = true
                            showingSheet = true
                            self.partialSheetManager.showPartialSheet() {
                                SheetView(club: club)
                            }
                        }
                }
            }
                .edgesIgnoringSafeArea(.bottom)
                .addPartialSheet(style: .defaultStyle())
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

struct SheetView: View {
    var club: Club
    @State private var showingDetailScreen = false
    @EnvironmentObject var store: ClubStore
    
    var clubIndex: Int {
        store.clubs.firstIndex(where: { $0.id == club.id })!
    }
    
    var body: some View {
        VStack {
            Text( club.clubname )
                .font(.headline)
            
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
            HStack {
                Spacer()
                VStack {
                    Text( club.association )
                        .padding(.top)
                    Text( club.town )
                        .padding(.bottom)
                }
                Spacer()
                FavoriteButton(isSet: $store.clubs[clubIndex].fav, clubID: club.clubId)
                Spacer()
            }
        }
        .onDisappear {
            for index in self.store.clubs.indices {
                self.store.clubs[index].show = false
            }
        }
        .sheet(isPresented: $showingDetailScreen, content: {
            DetailView(clubID: club.clubId)
        })
    }
}

struct AnnotatedMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AnnotatedMapView().environmentObject(ClubStore())
                .environmentObject(PartialSheetManager())
        }
    }
}
