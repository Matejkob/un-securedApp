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
    
    var baseURL: URL { URL(string: Configurator.baseUrl)! }
    
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
            return .requestParameters(bodyParameters: nil, urlParameters: ["api_key": Configurator.apiKey, "session_id": sessionId])
        }
    }
    
    var headers: HTTPHeaders? { nil }
}
