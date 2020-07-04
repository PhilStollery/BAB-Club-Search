//
//  ClubStore.swift
//  BAB Club Search
//
//  Created by Phil Stollery on 04/07/2020.
//

import Foundation

class ClubStore: ObservableObject {
    @Published var clubs: [Club]
    
    init(clubs: [Club] = []) {
        self.clubs = clubs
    }
}

let testStore = ClubStore(clubs: testData)
