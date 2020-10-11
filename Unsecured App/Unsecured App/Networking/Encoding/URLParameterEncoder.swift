//
//  URLParameterEncoder.swift
//  NetworkingLayer
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 x-kom. All rights reserved.
//

import Foundation

struct URLParameterEncoder: ParameterEncoder {
	public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
		guard let url = urlRequest.url else { throw EncodingError.missingURL }

		if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
			urlComponents.queryItems = []

			for (key, value) in parameters {
				let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
				urlComponents.queryItems?.append(queryItem)
			}
			urlRequest.url = urlComponents.url
		}

		if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
			urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8; ", forHTTPHeaderField: "Content-Type")
		}
	}
}
