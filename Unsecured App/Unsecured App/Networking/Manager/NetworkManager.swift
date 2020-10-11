//
//  NetworkManager.swift
//  NetworkingLayer
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 x-kom. All rights reserved.
//

import Foundation

protocol NetworkProvider {
	associatedtype EndPoint: EndPointType
	associatedtype Data: Decodable
	func request(from route: EndPoint, completion: @escaping (NetworkResponse<Data, Error>) -> Void)
    func cancel()
}

enum NetworkResponse<T, Error> {
	case success(T)
	case failure(Error)
}

struct NetworkManager<EndPoint: EndPointType, Data: Decodable> {

	private let router = Router<EndPoint>()

}

extension NetworkManager: NetworkProvider {
	func request(from route: EndPoint, completion: @escaping (NetworkResponse<Data, Error>) -> Void) {
		router.request(route) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}

			guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkHTTPURLResponse.failed))
				return
			}
			switch Self.handleNetworkResponse(response) {
				case .failure(let error):
                    completion(.failure(error))
				case .success:
					guard let data = data else {
                        completion(.failure(NetworkHTTPURLResponse.failed))
						return
					}

					do {
						let apiResponse = try JSONDecoder().decode(Data.self, from: data)
						completion(.success(apiResponse))
					} catch {
						completion(.failure(error))
				}
			}
		}
	}
    
    func cancel() {
        router.cancel()
    }
}

extension NetworkManager {
	private static func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkHTTPURLResponseResult<Error> {
		switch response.statusCode {
		case 200...299:
			return .success
		case 401...500:
			return .failure(NetworkHTTPURLResponse.authenticationError)
		case 501...599:
			return .failure(NetworkHTTPURLResponse.badRequest)
		case 600:
			return .failure(NetworkHTTPURLResponse.outdated)
		default:
			return .failure(NetworkHTTPURLResponse.failed)
		}
	}
}

extension NetworkManager {
	enum NetworkHTTPURLResponse: String, Error {
		case authenticationError = "You need to be authenticated first."
		case badRequest = "Bad request."
		case outdated = "The url you requested is outdated."
		case failed = "Network request failed."
		case noData = "Response returned with no data to decode."
		case unableToDecode = "We could not decode the response."
	}

	enum NetworkHTTPURLResponseResult<Error> {
		case success
		case failure(Error)
	}
}
