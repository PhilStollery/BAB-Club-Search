//
//  ContentView.swift
//  Shared
//
//  Created by Phil Stollery on 03/07/2020.
//

import SwiftUI
import SwiftlySearch

struct ContentView: View {
    
    @ObservedObject var store: ClubStore
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List{
                HStack {
                    Spacer()
                    Text("\(store.clubs.filter{$0.hasPrefix(search: searchText) || searchText == ""}.count) clubs")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                
                ForEach(store.clubs.filter{$0.hasPrefix(search: searchText) || searchText == ""}, id: \.id) { club in
                    ClubCell(club: club)
                }
            }
            .navigationTitle("Dojos")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink("About", destination: About())

                }
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink("Map View", destination: AllClubs(store: store))

                }
            }
            .navigationBarSearch(self.$searchText)
            
            Text("Choose a Dojo")
                .font(.largeTitle)
        }
    }
}

struct ClubCell: View {
    var club: Club
    
    var body: some View {
        NavigationLink(destination: ClubLocation(club: club)) {
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
