//
//  ClubLocation.swift
//  BAB Club Dearch
//
//  Created by Phil Stollery on 03/07/2020.
//

import SwiftUI

struct ClubLocation: View {
    var club: Club
    
    var body: some View {
        MapView()
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct ClubLocation_Previews: PreviewProvider {
    static var previews: some View {
        ClubLocation(club: testData[2])
    }
}
