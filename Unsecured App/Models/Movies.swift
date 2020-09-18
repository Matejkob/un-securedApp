//
//  Movies.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

struct Movies: Codable, Hashable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int
    
    private var type: MoviesType?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

extension Movies {
    func getType() -> MoviesType? {
        type
    }
    
    mutating func setType(_ type: MoviesType) {
        self.type = type
    }
    
    enum MoviesType: Int {
        case nowPlaying = 1
        case popular = 2
        case topRated = 3
        case upcoming = 0
        
        var title: String {
            switch self {
            case .nowPlaying:
                return "W kinach"
            case .popular:
                return "Popularne"
            case .topRated:
                return "Najwyżej oceniane"
            case .upcoming:
                return "Nadchodzące premiery"
            }
        }
        
        var subtitle: String {
            switch self {
            case .nowPlaying:
                return "Aktualny repertuar kin"
            case .popular:
                return "Lista najpopularniejszych filmów"
            case .topRated:
                return "Największe hity według naszych Was"
            case .upcoming:
                return "Przygotuj się na nadchodzące premiery"
            }
        }
    }
}
