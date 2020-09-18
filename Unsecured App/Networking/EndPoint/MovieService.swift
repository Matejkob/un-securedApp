//
//  MovieService.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

enum MovieService: EndPointType {
    
    private static let baseUrlParameters: Parameters = ["api_key": "24bea9453e359d032e2fba722a9d8e4f", "language": "pl_PL"]
    
    case nowPlaying(page: Int)
    case popular(page: Int)
    case topRated(page: Int)
    case upcoming(page: Int)
    
    case details(movieId: Int)
    
    var baseURL: URL { URL(string: "https://api.themoviedb.org/3/movie/")! }
    
    var path: String {
        switch self {
        case .nowPlaying:
            return "now_playing"
        case .popular:
            return "popular"
        case .topRated:
            return "top_rated"
        case .upcoming:
            return "upcoming"
        case .details(let movieId):
            return "\(movieId)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {s
        case .nowPlaying, .popular, .topRated, .upcoming, .details:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .nowPlaying(let page), .popular(let page), .topRated(let page), .upcoming(let page):
            let urlParameters: NSMutableDictionary = ["page": page]
            urlParameters.addEntries(from: Self.baseUrlParameters)
            return .requestParameters(bodyParameters: nil, urlParameters: urlParameters as? Parameters)
        case .details:
            return .requestParameters(bodyParameters: nil, urlParameters: Self.baseUrlParameters)
        }
    }
    
    var headers: HTTPHeaders? { nil }
}
