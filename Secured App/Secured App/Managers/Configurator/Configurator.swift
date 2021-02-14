//
//  Configurator.swift
//  Secured App
//
//  Created by Mateusz Bąk on 11/10/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

struct Configurator {
    
    private static let o = Obfuscator()
    
    // MARK: - API
    
    static let apiKey = o.reveal(key: [115, 68, 18, 33, 4, 85, 81, 82, 82, 17, 86, 123, 106, 43, 82, 89, 87, 6, 70, 39, 18, 17, 115, 87, 94, 4, 94, 5, 76, 0, 122, 53])
    
    static let baseUrl = "https://api.themoviedb.org/3/"
    
    // MARK: - Images
    
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w780"
    
    static let originalImageBaseUrl = "https://image.tmdb.org/t/p/original"
    
    static let gravataBaseUrl = "https://www.gravatar.com/avatar/"
    
    
    // MARK: - Database
        
    static let sessionIdDatabaseKey = o.reveal(key: [50, 21, 3, 55, 12, 3, 11, 46, 5, 48, 4, 58, 50, 45, 3, 25, 0, 40, 17, 56])
    
}
