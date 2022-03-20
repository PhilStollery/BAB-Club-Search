//
//  AnnotatedMapView.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 17/07/2020.
//

import MapKit
import SwiftUI
import PartialSheet
import Combine

struct AnnotatedMapView: View {
    
    @ObservedObject private var locationManager = LocationManager()
    @EnvironmentObject var store: ClubStore
    @EnvironmentObject var partialSheetManager : PartialSheetManager
    @State private var showingSheet = false
    @State private var feedback = UISelectionFeedbackGenerator()
    @ObservedObject private var tracker: trackingModel = trackingModel()
    
    var body: some View {
        ZStack {
            Map(mapRect: $store.mapRect,
                showsUserLocation: true,
                userTrackingMode: $tracker.userTrackingMode,
                annotationItems: self.store.clubs) {
                club in MapAnnotation(coordinate: club.coordinate) {
                    Image(systemName: "house.circle")
                        .font(.title)
                        .foregroundColor(club.show ? Color.primary : club.fav ? Color.yellow : Color.accentColor)
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
        .onAppear {
            self.feedback.selectionChanged()
        }
        .navigationBarTitle(Text("Map View"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                withAnimation {
                    tracker.userTrackingMode = tracker.userTrackingMode == .none ? .follow : .none
                }
        })
            {Image(systemName: tracker.userTrackingMode == .follow ? "location.fill" : "location")}
        )
    }
}

// possible hack to stop modifying state while the UI is updating
class trackingModel: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    var userTrackingMode: MapUserTrackingMode = .none  {
        willSet {
            objectWillChange.send()
        }
    }
}

struct SheetView: View {
    var club: Club
    @State private var showingDetailScreen = false
    @EnvironmentObject var store: ClubStore
    @State private var feedback = UISelectionFeedbackGenerator()
    
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
        .onAppear {
            self.feedback.selectionChanged()
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
