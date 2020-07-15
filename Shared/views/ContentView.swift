//
//  ContentView.swift
//  Shared
//
//  Created by Phil Stollery on 03/07/2020.
//

import SwiftUI
import SwiftlySearch

struct ContentView: View {
    
    @ObservedObject var store = ClubStore()
    @State private var searchText = ""
    @State private var downloadAmount = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    
    var body: some View {
        Group {
            // API call has loaded the clubs
            if store.dataLoaded {
                NavigationView {
                    List{
                        HStack {
                            Spacer()
                            Text("\(store.clubs!.filter{$0.hasPrefix(search: searchText) || searchText == ""}.count) clubs")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                        
                        ForEach(store.clubs!.filter{$0.hasPrefix(search: searchText) || searchText == ""}, id: \.id) { club in
                            ClubCell(club: club)
                        }
                    }
                    .navigationTitle("Dojos")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            NavigationLink("About", destination: AboutView())

                        }
                        ToolbarItem(placement: .primaryAction) {
                            NavigationLink("Map View", destination: AllClubsView(store: store))

                        }
                    }
                    .navigationBarSearch(self.$searchText)
                    
                    Text("Choose a Dojo or view them all on a map.")
                        .font(.largeTitle)
                }
            } else {
                HStack {
                    Text("Loading data from the BAB")
                    ProgressView()
                        .padding(.leading, 15.0)
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
        }.onAppear {
            self.store.loadXML(urlString: "https://www.bab.org.uk/wp-content/plugins/bab-clubs/googlemap/wordpress_clubs_xml.asp?lat=0&lng=0&radius=10&assoc=all&coach=all")
        }
    }
}

struct ClubCell: View {
    var club: Club
    
    var body: some View {
        NavigationLink(destination: ClubLocationView(club: club)) {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(store: ClubStore())
            ContentView(store: ClubStore())
                .preferredColorScheme(.dark)
        }
    }
}
