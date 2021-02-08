//
//  BAB_Club_SearchApp.swift
//  Shared
//
//  Created by Phil Stollery on 03/07/2020.
//

import SwiftUI

@main
struct BAB_Club_SearchApp: App {
    @StateObject private var store = ClubStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(store)
        }
    }
}


