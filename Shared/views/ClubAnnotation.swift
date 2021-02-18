//
//  ClubAnnotation.swift
//  iOS
//
//  Created by Phil Stollery on 06/02/2021.
//

import SwiftUI

struct ClubAnnotation: View {
    
    @ObservedObject var annotate: Club
    
    var body: some View {
        LazyHStack {
            if annotate.show {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(radius: 2, x: 2, y: 2)
                    VStack{
                        NavigationLink(destination: ClubLocationView(club: annotate)) {
                            Text(annotate.clubname)
                                .fontWeight(.bold)
                        }
                        .padding()
                        Text(annotate.association)
                            .padding(.leading)
                            .padding(.trailing)
                        Text(annotate.town)
                            .padding(.bottom)
                    }
                }
            } else {
                Image(systemName: "house.circle")
                    .font(.title)
                    .foregroundColor(.accentColor)
            }
        }
        .onTapGesture{ annotate.show.toggle() }
    }
}

struct ClubAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ClubAnnotation(annotate: testData[3])
        }
    }
}
