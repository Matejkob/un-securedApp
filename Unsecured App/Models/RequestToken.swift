//
//  RequestToken.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 24/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

struct RequestToken: Codable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
