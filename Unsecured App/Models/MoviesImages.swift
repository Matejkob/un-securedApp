//
//  MoviesImages.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 18/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

struct MoviesImages: Codable, Hashable {
    let id: Int
    let backdrops, posters: [Backdrop]
}

extension MoviesImages {
    static let baseUrl = "https://image.tmdb.org/t/p/w780"
}
