//
//  AccountService.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 24/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

enum AccountService: EndPointType {
    
    case account(sessionId: String)
    
    var baseURL: URL { URL(string: "https://api.themoviedb.org/3")! }
    
    var path: String {
        switch self {
        case .account:
            return "account"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .account:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .account(let sessionId):
            return .requestParameters(bodyParameters: nil, urlParameters: ["api_key": "24bea9453e359d032e2fba722a9d8e4f", "session_id": sessionId])
        }
    }
    
    var headers: HTTPHeaders? { nil }
}
