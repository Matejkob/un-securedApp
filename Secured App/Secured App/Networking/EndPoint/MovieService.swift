//
//  MovieService.swift
//  Secured App
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

enum MovieService: EndPointType {
    
    private static let baseUrlParameters: Parameters = ["api_key": Configurator.apiKey, "language": "pl-PL"]
    
    case nowPlaying(page: Int)
    case popular(page: Int)
    case topRated(page: Int)
    case upcoming(page: Int)
    case details(movieId: Int)
    case images(movieId: Int)
    case videos(movieId: Int)
    case recommendations(movieId: Int)
    case credits(movieId: Int)
    
    var baseURL: URL { URL(string: Configurator.baseUrl + "movie")! }
    
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
        case .images(let movieId):
            return "\(movieId)/images"
        case .videos(let movieId):
            return "\(movieId)/viedos"
        case .recommendations(let movieId):
            return "\(movieId)/recommendations"
        case .credits(let movieId):
            return "\(movieId)/credits"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .nowPlaying, .popular, .topRated, .upcoming, .details, .images, .recommendations, .credits, .videos:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .nowPlaying(let page):
            let urlParameters: NSMutableDictionary = ["page": page]
            urlParameters.addEntries(from: ["region": LocationManager.shared.getRegionCode()])
            urlParameters.addEntries(from: Self.baseUrlParameters)
            return .requestParameters(bodyParameters: nil, urlParameters: urlParameters as? Parameters)
        case .popular(let page), .topRated(let page), .upcoming(let page):
            let urlParameters: NSMutableDictionary = ["page": page]
            urlParameters.addEntries(from: Self.baseUrlParameters)
            return .requestParameters(bodyParameters: nil, urlParameters: urlParameters as? Parameters)
        case .details, .recommendations, .videos:
            return .requestParameters(bodyParameters: nil, urlParameters: Self.baseUrlParameters)
        case .images, .credits:
            return .requestParameters(bodyParameters: nil, urlParameters: ["api_key": Configurator.apiKey])
        }
    }
    
    var headers: HTTPHeaders? { nil }
}
