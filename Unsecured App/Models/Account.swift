//
//  Account.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 24/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

struct Account: Codable {
    let avatar: Avatar
    let id: Int
    let iso639_1, iso3166_1, name: String
    let includeAdult: Bool
    let username: String

    enum CodingKeys: String, CodingKey {
        case avatar, id
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name
        case includeAdult = "include_adult"
        case username
    }
}
