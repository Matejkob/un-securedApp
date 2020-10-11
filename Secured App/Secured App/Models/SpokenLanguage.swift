//
//  SpokenLanguage.swift
//  Secured App
//
//  Created by Mateusz Bąk on 18/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

struct SpokenLanguage: Codable, Hashable {
    let iso639_1, name: String

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case name
    }
}
