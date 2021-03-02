//
//  BAB_Club_SearchApp.swift
//  Shared
//
//  Created by Phil Stollery on 03/07/2020.
//

import SwiftUI
import PartialSheet

@main
struct BAB_Club_SearchApp: App {
    @StateObject private var store = ClubStore()
    @StateObject var userSettings = UserSettings()
    let sheetManager: PartialSheetManager = PartialSheetManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(userSettings)
                .environmentObject(sheetManager)
        }
    }
}
