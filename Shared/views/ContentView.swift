//
//  ContentView.swift
//  Shared
//
//  Created by Phil Stollery on 03/07/2020.
//

import SwiftUI
import SwiftlySearch

struct ContentView: View {
    
    @EnvironmentObject var store: ClubStore
    @State private var downloadAmount = 0.0
    @State private var searchText = ""

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
                    .navigationBarItems(
                        leading: NavigationLink("About", destination: AboutView()),
                        trailing: NavigationLink("Map View", destination: AnnotatedMapView())
                    )
                    .navigationBarSearch(self.$searchText)
                    
                    Text("Choose a Dojo or view them all on a map.")
                        .font(.title)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            } else {
                VStack {
                    ProgressView("Loading data from the BAB")
                        .padding(.leading, 15.0)
                        .font(/*@START_MENU_TOKEN@*/.title2/*@END_MENU_TOKEN@*/)
                }
            }
        }.onAppear {
            store.loadXML(urlString: "https://www.bab.org.uk/wp-content/plugins/bab-clubs/googlemap/wordpress_clubs_xml.asp?lat=0&lng=0&radius=10&assoc=all&coach=all")
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
            ContentView().environmentObject(ClubStore())
            ContentView().environmentObject(ClubStore())
                .preferredColorScheme(.dark)
        }
    }
}
