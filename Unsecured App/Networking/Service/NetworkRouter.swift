//
//  NetworkRouter.swift
//  NetworkingLayer
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 x-kom. All rights reserved.
//

import Foundation

typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol NetworkRouter {
	associatedtype EndPoint: EndPointType
	func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
	func cancel()
}
