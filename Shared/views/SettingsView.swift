//
//  SettingsView.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 28/02/2021.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var userSettings = UserSettings()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("PROFILE")) {
                    TextField("Username", text: $userSettings.username)
                }
            }
            .navigationBarTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button(action: {presentationMode.wrappedValue.dismiss()}) {
                        HStack {
                            Text("Close Settings")
                            Image(systemName: "chevron.down")
                        }
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
