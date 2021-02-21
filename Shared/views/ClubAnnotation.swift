//
//  ClubAnnotation.swift
//  iOS
//
//  Created by Phil Stollery on 06/02/2021.
//

import SwiftUI

struct ClubAnnotation: View {
    
    @State var clubIndex: Int
    @EnvironmentObject var store: ClubStore
    
    var body: some View {
        LazyHStack {
            if store.clubs[clubIndex].show {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(radius: 2, x: 2, y: 2)
                    VStack{
                        NavigationLink(destination: ClubLocationView(club:  store.clubs[clubIndex])) {
                            Text( store.clubs[clubIndex].clubname)
                                .fontWeight(.bold)
                        }
                        .padding()
                        Text( store.clubs[clubIndex].association)
                            .padding(.leading)
                            .padding(.trailing)
                        Text( store.clubs[clubIndex].town)
                            .padding(.bottom)
                    }
                }
            } else {
                Image(systemName: "house.circle")
                    .font(.title)
                    .foregroundColor(.accentColor)
            }
        }
        .onTapGesture{ store.clubs[clubIndex].show.toggle() }
    }
}


struct ClubAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ClubAnnotation(clubIndex: 66).environmentObject(ClubStore())
        }
    }
}

