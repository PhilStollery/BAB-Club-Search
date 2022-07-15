//
//  FavouriteButton.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 01/03/2021.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool
    @State private var impactMed = UIImpactFeedbackGenerator(style: .heavy)
    @ObservedObject var userSettings = UserSettings()
    
    var clubID: Int
    let appData = UserDefaults.standard
    
    var body: some View {
        Button(action: {
            isSet.toggle()
            if (isSet) {
                userSettings.favs.append(clubID)
            } else {
                if let indexToRemove = userSettings.favs.firstIndex(of: clubID) {
                    userSettings.favs.remove(at: indexToRemove)
                }
            }
            self.impactMed.impactOccurred()
        }) {
            Image(systemName: isSet ? "star.fill" : "star")
                .foregroundColor(isSet ? Color.yellow : Color.gray)
                .font(.largeTitle)
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(isSet: .constant(true), clubID: 4)
        FavoriteButton(isSet: .constant(false), clubID: 4)
    }
}
