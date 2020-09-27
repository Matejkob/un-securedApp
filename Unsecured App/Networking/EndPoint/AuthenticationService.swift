//
//  AuthenticationService.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 24/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

enum AuthenticationService: EndPointType {
    
    case createRequestToken
    case createSession(requestToken: String)
    case createSessionWithLogin(username: String, password: String, requestToken: String)
    case createSessionFromAccessToken(accessToken: String)
    case deleteSession(sessionId: String)
    
    var baseURL: URL { URL(string: "https://api.themoviedb.org/3/authentication/")! }
    
    var path: String {
        switch self {
        case .createRequestToken:
            return "token/new"
        case .createSession:
            return "session/new"
        case .createSessionWithLogin:
            return "token/validate_with_login"
        case .createSessionFromAccessToken:
            return "session/convert/4"
        case .deleteSession:
            return "session"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .createRequestToken:
            return .get
        case .createSession, .createSessionWithLogin, .createSessionFromAccessToken:
            return .post
        case .deleteSession:
            return .delete
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .createRequestToken:
            return .requestParameters(bodyParameters: nil, urlParameters: ["api_key": "24bea9453e359d032e2fba722a9d8e4f"])
        case .createSession(let requestToken):
            return .requestParameters(bodyParameters: ["request_token": requestToken], urlParameters: ["api_key": "24bea9453e359d032e2fba722a9d8e4f"])
        case let .createSessionWithLogin(username, password, requestToken):
            return .requestParameters(bodyParameters: ["username": username, "password": password, "request_token": requestToken], urlParameters: ["api_key": "24bea9453e359d032e2fba722a9d8e4f"])
        case .createSessionFromAccessToken(let accessToken):
            return .requestParameters(bodyParameters: ["access_token": accessToken], urlParameters: ["api_key": "24bea9453e359d032e2fba722a9d8e4f"])
        case .deleteSession(let sessionId):
            return .requestParameters(bodyParameters: ["session_id": sessionId], urlParameters: ["api_key": "24bea9453e359d032e2fba722a9d8e4f"])
        }
    }
    
    var headers: HTTPHeaders? { nil }
}
