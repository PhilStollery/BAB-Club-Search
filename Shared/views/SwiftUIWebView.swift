//
//  SwiftUIWebView.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 17/07/2020.
//

import SwiftUI

struct SwiftUIWebView: View {
    var viewURL: URL
    
    var body: some View {
        VStack{
            Text("Loading details from the BAB...")
            UrlWebView(urlToDisplay: viewURL)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct SwiftUIWebView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIWebView(viewURL: URL(string: "https://www.bab.org.uk/clubs/club-search/?ViewClubMapID=53")!)
    }
}
