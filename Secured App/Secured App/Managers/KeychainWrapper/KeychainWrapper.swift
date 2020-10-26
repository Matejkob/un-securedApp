//
//  KeychainWrapper.swift
//  Secured App
//
//  Created by Mateusz Bąk on 11/10/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

protocol KeychainWrapperProtocol {
    func set(value: Data, account: String) throws
    func get(account: String) throws -> Data?
    func delete(account: String) throws
}

struct KeychainWrapper: KeychainWrapperProtocol {
    
    let keychainOperations: KeychainOperationsProtocol
    
    func set(value: Data, account: String) throws {
        try keychainOperations.set(value: value, account: account)
    }
    
    func get(account: String) throws -> Data? {
        try keychainOperations.retreive(account: account)
    }
    
    func delete(account: String) throws {
        try keychainOperations.delete(account: account)
    }
}
