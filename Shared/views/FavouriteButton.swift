//
//  FavouriteButton.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 01/03/2021.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool
    var clubID: Int
    let appData = UserDefaults.standard
    
    var body: some View {
        Button(action: {
            var favs: [Int] = appData.object(forKey: "storedFavs") as? [Int] ?? []
            isSet.toggle()
            if (isSet) {
                favs.append(clubID)
            } else {
                if let indexToRemove = favs.firstIndex(of: clubID) {
                    favs.remove(at: indexToRemove)
                }
            }
            appData.set(favs, forKey: "storedFavs")
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
