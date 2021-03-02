//
//  SettingsView.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 28/02/2021.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("OPTIONS")) {
                    Toggle(isOn: $userSettings.highlightFavs) {
                        Text("Highlight favs")
                    }
                    Toggle(isOn: $userSettings.filterOrganisation) {
                        Text("Only show your organisation")
                    }
                    Picker(selection: $userSettings.organisation, label: Text("Organisations")) {
                        ForEach(userSettings.organisations, id: \.self) { org in
                            Text(org)
                        }
                    }
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
