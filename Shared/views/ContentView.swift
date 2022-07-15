//
//  ContentView.swift
//  Shared
//
//  Created by Phil Stollery on 03/07/2020.
//

import SwiftUI

@available(iOS 15.0, *)
struct ContentView: View {
    
    @EnvironmentObject var store: ClubStore
    @State private var searchText = ""
    @State private var filterFavs = false
    @State private var impactMed = UIImpactFeedbackGenerator(style: .heavy)
    @State private var feedback = UISelectionFeedbackGenerator()
    @ObservedObject var userSettings = UserSettings()

    var body: some View {
        NavigationView {
            List{
                HStack {
                    Text("\(store.clubs.filter{(($0.hasPrefix(search: searchText) || searchText == "") && filterFavs == false) || (filterFavs == true && $0.fav == true )}.count) clubs")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Toggle("Filter favs", isOn: $filterFavs)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: Color.yellow))
                }
                
                ForEach(store.clubs.filter{(($0.hasPrefix(search: searchText) || searchText == "") && filterFavs == false) ||
                            ( filterFavs == true && $0.fav == true )}) {
                    club in ClubCell(club: club)
                        .swipeActions(edge: .leading) {
                            Button(action:{
                                let clubIndex = store.clubs.firstIndex(where: { $0.id == club.id })!
                                store.clubs[clubIndex].fav.toggle()
                                if (!club.fav) {
                                    userSettings.favs.append(club.clubId)
                                } else {
                                    if let indexToRemove = userSettings.favs.firstIndex(of: club.clubId) {
                                        userSettings.favs.remove(at: indexToRemove)
                                    }
                                }
                                self.impactMed.impactOccurred()
                            }){
                                Image(systemName: club.fav == true ? "star" : "star.fill")
                            }.tint(Color.yellow)
                        }
                }
            }
            .overlay {
                if !store.dataLoaded {
                    VStack {
                        ProgressView()
                            .padding()
                        Text("Network connection needed to download dojo information.")
                        .multilineTextAlignment(.center)
                        .padding()
                    }
                }
            }
            .onAppear {
                self.feedback.selectionChanged()
            }
            .refreshable {
                await store.updateClubs()
            }
            .listStyle(.plain)
            .navigationTitle("Dojos")
            .navigationBarItems(
                leading:NavigationLink("About", destination: AboutView()),
                trailing: NavigationLink("Map View", destination: AnnotatedMapView()))
            .searchable(text: $searchText, prompt: "Search for your dojo")
        }
        .task { await store.updateClubs() }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ClubCell: View {
    var club: Club
    
    var body: some View {
        NavigationLink(destination: ClubLocationView(passedClub: club)) {
            HStack {
                VStack(alignment: .leading) {
                    Text(club.clubname)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text(club.town)
                        .foregroundColor(.accentColor)
                    Text(club.association)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if (club.fav) {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.yellow)
                }
            }
        }
    }
}

@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environmentObject(ClubStore())
            ContentView().environmentObject(ClubStore())
                .preferredColorScheme(.dark)
        }
    }
}
