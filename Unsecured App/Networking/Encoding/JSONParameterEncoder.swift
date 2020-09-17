//
//  JSONParameterEncoder.swift
//  NetworkingLayer
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 x-kom. All rights reserved.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder {
	public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
		do {
			let jsonParameters = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
			urlRequest.httpBody = jsonParameters
			if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
				urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
			}
		} catch {
			throw EncodingError.encodingFailed
		}
	}
}
