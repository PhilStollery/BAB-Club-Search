//
//  ContentView.swift
//  Shared
//
//  Created by Phil Stollery on 03/07/2020.
//

import SwiftUI

struct ContentView: View {
    
    var clubs: [Club] = []
    
    var body: some View {
        NavigationView {
            List{
                ForEach(clubs) { club in
                    ClubCell(club: club)
                }
                
                HStack {
                    Spacer()
                    Text("\(clubs.count) clubs")
                        .foregroundColor(.secondary)
                }
                    
            }
            .navigationTitle("Dojos")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(clubs: testData)
    }
}

struct ClubCell: View {
    var club: Club
    
    var body: some View {
        NavigationLink(destination: Text(club.clubname)) {
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
