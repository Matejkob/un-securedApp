//
//  Router.swift
//  NetworkingLayer
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 x-kom. All rights reserved.
//

import Foundation

final class Router<EndPoint: EndPointType>: NSObject, NetworkRouter, URLSessionDelegate {

	private var task: URLSessionTask?
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        guard validate(trust: serverTrust, with: SecPolicyCreateBasicX509()),
              let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        guard let localCertificate = CertificateHelper.themoviedb else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        guard let serverCertificatePublicKey = publicKey(for: serverCertificate),
              let localCertificatePublicKey = publicKey(for: localCertificate),
              serverCertificatePublicKey == localCertificatePublicKey else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        completionHandler(.useCredential, URLCredential(trust: serverTrust))
    }
}

extension Router {
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

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

    func cancel() {
        task?.cancel()
    }
}

private extension Router {
    func buildRequest(from route: EndPoint) throws -> URLRequest {
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

    func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
		do {
			if let bodyParameters = bodyParameters {
				try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
			}

			if let urlParameters = urlParameters {
				try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
			}
		} catch {
			throw error
		}
	}

    func addAdditionalHeaders(_ additionHeaders: HTTPHeaders?, request: inout URLRequest) {
		guard let additionHeaders = additionHeaders else { return }

		for (key, value) in additionHeaders {
			request.setValue(value, forHTTPHeaderField: key)
		}
	}
}

private extension Router {
    func validate(trust: SecTrust, with policy: SecPolicy) -> Bool {
        let status = SecTrustSetPolicies(trust, policy)
        
        guard status == errSecSuccess else { return false }
        
        return SecTrustEvaluateWithError(trust, nil)
    }
    
    func publicKey(for certificate: SecCertificate) -> SecKey? {
        var publicKey: SecKey?
        
        var trust: SecTrust?
        let trustCreationStatus = SecTrustCreateWithCertificates(certificate, SecPolicyCreateBasicX509(), &trust)
        
        if let trust = trust, trustCreationStatus == errSecSuccess {
            publicKey = SecTrustCopyPublicKey(trust)
        }
        
        return publicKey
    }
    
    func certificateData(for certificates: [SecCertificate]) -> [Data] {
        return certificates.map { SecCertificateCopyData($0) as Data }
    }
}
