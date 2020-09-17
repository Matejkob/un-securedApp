//
//  Router.swift
//  NetworkingLayer
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 x-kom. All rights reserved.
//

import Foundation

public class Router<EndPoint: EndPointType>: NetworkRouter {

	private var task: URLSessionTask?

	public func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
		let session = URLSession.shared

		do {
			let request = try buildRequest(from: route)
			task = session.dataTask(with: request, completionHandler: { data, response, error in
				completion(data, response, error)
			})
		} catch {
			completion(nil, nil, error)
		}

		task?.resume()
	}

	public func cancel() {
		task?.cancel()
	}
}

extension Router {
	private func buildRequest(from route: EndPoint) throws -> URLRequest {
		var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
		request.httpMethod = route.httpMethod.rawValue

		do {
			switch route.task {
			case .request:
				request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			case .requestParameters(bodyParameters: let bodyParameters, urlParameters: let urlParameters):
				try configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
			case .requestParametersAndHeaders(bodyParameters: let bodyParameters, urlParameters: let urlParameters, additionHeaders: let additionHeaders):
				addAdditionalHeaders(additionHeaders, request: &request)
				try configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
			}
			return request
		} catch {
			throw error
		}
	}

	private func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
		do {
			if let bodyParameters = bodyParameters {
				try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
			}

			if let urlParameters = urlParameters {
				try JSONParameterEncoder.encode(urlRequest: &request, with: urlParameters)
			}
		} catch {
			throw error
		}
	}

	private func addAdditionalHeaders(_ additionHeaders: HTTPHeaders?, request: inout URLRequest) {
		guard let additionHeaders = additionHeaders else { return }

		for (key, value) in additionHeaders {
			request.setValue(value, forHTTPHeaderField: key)
		}
	}
}
