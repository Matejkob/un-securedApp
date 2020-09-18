//
//  Credits.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 18/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

struct Credits: Codable, Hashable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]
}
