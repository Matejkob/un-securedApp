//
//  PostService.swift
//  NetworkingLayer
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 x-kom. All rights reserved.
//

import Foundation

enum PostService: EndPointType {

	case all
    case comments(postIt: Int)

	var baseURL: URL {
		return URL(string: "https://jsonplaceholder.typicode.com/")!
	}

	var path: String {
		switch self {
        case .all:
            return "posts"
        case .comments:
            return "comments"
        }
	}

	var httpMethod: HTTPMethod {
		return .get
	}

	var task: HTTPTask {
		switch self {
        case .all:
			return .request
        case let .comments(postId):
            let parameters = ["postId": postId]
			return .requestParameters(bodyParameters: nil, urlParameters: parameters)
        }
	}

	var headers: HTTPHeaders? {
		return nil
	}
}

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
}
