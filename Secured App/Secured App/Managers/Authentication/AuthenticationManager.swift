//
//  AuthenticationManager.swift
//  Secured App
//
//  Created by Mateusz Bąk on 24/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

protocol AuthenticationManagerProtocol {
    func createSessionWith(username: String, password: String, completion: @escaping (Error?) -> Void)
    func getSessionToken() -> String?
    func removeSessionToken()
}

struct AuthenticationManager: AuthenticationManagerProtocol {
        
    private let requestTokenNetworkManager = NetworkManager<AuthenticationService, RequestToken>()
    private let sessionNetworkManager = NetworkManager<AuthenticationService, Session>()
    private let keychainWrapper: KeychainWrapperProtocol = KeychainWrapper(keychainOperations: KeychainOperations())
    
}

extension AuthenticationManager {
    func createSessionWith(username: String, password: String, completion: @escaping (Error?) -> Void) {
        createRequestToken(username: username, password: password, completion: completion)
    }
    
    func getSessionToken() -> String? {
        do {
            guard let data = try keychainWrapper.get(account: Configurator.sessionIdDatabaseKey) else { return nil }
            let sessionToken = String(data: data, encoding: .utf8)
            return sessionToken
        } catch {
            print(error)
            return nil
        }
    }
    
    func removeSessionToken() {
        do {
            try keychainWrapper.delete(account: Configurator.sessionIdDatabaseKey)
        } catch {
            print(error)
        }
    }
}

private extension AuthenticationManager {
    func createRequestToken(username: String, password: String, completion: @escaping (Error?) -> Void) {
        requestTokenNetworkManager.request(from: .createRequestToken) { result in
            switch result {
            case .success(let requestToken):
                createSessionWithLogin(username: username, password: password, requestToken: requestToken.requestToken, completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func createSessionWithLogin(username: String, password: String, requestToken: String, completion: @escaping (Error?) -> Void) {
        requestTokenNetworkManager.request(from: .createSessionWithLogin(username: username, password: password, requestToken: requestToken)) { result in
            switch result {
            case .success(let requestToken):
                createSession(requestToken: requestToken.requestToken, completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func createSession(requestToken: String, completion: @escaping (Error?) -> Void) {
        sessionNetworkManager.request(from: .createSession(requestToken: requestToken)) { result in
            switch result {
            case .success(let session):
                do {
                    guard let sessionData = session.sessionID.data(using: .utf8) else {
                        completion(nil)
                        return
                    }
                    try keychainWrapper.set(value: sessionData, account: Configurator.sessionIdDatabaseKey)
                    
                    completion(nil)
                } catch {
                    completion(error)
                }
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}
