//
//  ContentView.swift
//  Shared
//
//  Created by Phil Stollery on 03/07/2020.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var store: ClubStore
    @State private var searchText = ""
    @State private var visibleClubs = 0
    
    var body: some View {
        NavigationView {
            
            List{
                SearchBar(text: $searchText)
                
                ForEach(store.clubs.filter{$0.hasPrefix(search: searchText) || searchText == ""}, id:\.self) { club in
                    ClubCell(club: club)
                }
                
                HStack {
                    Spacer()
                    Text("\(store.clubs.count) clubs")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Dojos")
            
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
