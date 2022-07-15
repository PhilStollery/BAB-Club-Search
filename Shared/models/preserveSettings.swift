//
//  preserveSettings.swift
//  iOS
//
//  Created by Phil Stollery on 15/07/2022.
//

import Foundation

class UserSettings: ObservableObject {
    @Published var favs: [Int] {
        didSet {
            UserDefaults.standard.set(favs, forKey: "favs")
        }
    }
    
    init() {
        self.favs = UserDefaults.standard.object(forKey: "favs") as? [Int] ?? []
    }
}
