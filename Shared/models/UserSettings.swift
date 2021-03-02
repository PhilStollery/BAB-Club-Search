//
//  UserSettings.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 28/02/2021.
//

import Foundation
import Combine

class UserSettings: ObservableObject {
    
    @Published var highlightFavs: Bool {
        didSet {
            UserDefaults.standard.set(highlightFavs, forKey: "highlightFavs")
        }
    }
    
    @Published var filterOrganisation: Bool {
        didSet {
            UserDefaults.standard.set(filterOrganisation, forKey: "filterOrganisation")
        }
    }
    

    @Published var organisation: String {
        didSet {
            UserDefaults.standard.set(organisation, forKey: "organisation")
        }
    }

    @Published var organisations: [String] {
        didSet {
            UserDefaults.standard.set(organisations, forKey: "organisations")
        }
    }
    
    init() {
        self.highlightFavs = UserDefaults.standard.object(forKey: "highlightFavs") as? Bool ?? false
        self.filterOrganisation = UserDefaults.standard.object(forKey: "filterOrganisation") as? Bool ?? false
        self.organisation = UserDefaults.standard.object(forKey: "organisation") as? String ?? "Chimes"
        self.organisations = UserDefaults.standard.object(forKey: "organisations") as? [String] ?? [""]
    }
}
