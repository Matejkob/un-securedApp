//
//  ParameterEncoding.swift
//  NetworkingLayer
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 x-kom. All rights reserved.
//

import Foundation

protocol ParameterEncoder {
	static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
