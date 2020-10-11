//
//  SearchService.swift
//  Secured App
//
//  Created by Mateusz Bąk on 22/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

enum SearchService: EndPointType {
    
    private static let baseUrlParameters: Parameters = ["api_key": Configurator.apiKey, "language": "pl-PL"]
    
    case movie(query: String, page: Int)
    
    var baseURL: URL { URL(string: Configurator.baseUrl + "search")! }
    
    var path: String {
        switch self {
        case .movie:
            return "movie"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .movie:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case let .movie(query, page):
            let urlParameters: NSMutableDictionary = ["page": page]
            urlParameters.addEntries(from: Self.baseUrlParameters)
            urlParameters.addEntries(from: ["query": query])
            return .requestParameters(bodyParameters: nil, urlParameters: urlParameters as? Parameters)
        }
    }
    
    var headers: HTTPHeaders? { nil }
}
