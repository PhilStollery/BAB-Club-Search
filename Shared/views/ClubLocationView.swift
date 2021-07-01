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
    @EnvironmentObject var store: ClubStore
    @State private var feedback = UISelectionFeedbackGenerator()
    
    var clubIndex: Int {
        store.clubs.firstIndex(where: { $0.id == club.id })!
    }
    
    init(passedClub: Club) {
        let getPoisiton = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: passedClub.lat, longitude: passedClub.lng), latitudinalMeters: 1500, longitudinalMeters: 1500)
        self._coordinateRegion = State(wrappedValue: getPoisiton)
        self.club = passedClub
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
            HStack{
                Spacer()
                VStack{
                    Text(club.association)
                        .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.secondary)
                        .padding(.top)
                    Text(club.town)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.secondary)
                        .padding(.bottom)
                }
                Spacer()
                FavoriteButton(isSet: $store.clubs[clubIndex].fav, clubID: club.clubId)
                Spacer()
            }
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
        .onAppear {
            self.feedback.selectionChanged()
        }
    }
}

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var feedback = UISelectionFeedbackGenerator()
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
        .onAppear {
            self.feedback.selectionChanged()
        }
    }
}

struct ClubLocation_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ClubLocationView(passedClub: testData[3])
            }.preferredColorScheme(.dark)
            NavigationView {
                ClubLocationView(passedClub: testData[4])
            }
        }
    }
}
