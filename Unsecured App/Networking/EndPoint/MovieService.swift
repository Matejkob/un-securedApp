//
//  MovieService.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

enum MovieService: EndPointType {
    
    case nowPlaying(page: Int)
    
    var baseURL: URL { URL(string: "https://api.themoviedb.org/3/movie/")! }
    
    var path: String {
        switch self {
        case .nowPlaying:
            return "now_playing"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .nowPlaying:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case let .nowPlaying(page):
            let urlParameters: [String : Any] = ["api_key": "24bea9453e359d032e2fba722a9d8e4f", "language": "pl_PL", "page": page]
            return .requestParameters(bodyParameters: nil, urlParameters: urlParameters)
        }
    }
    
    var headers: HTTPHeaders? { nil }
}
