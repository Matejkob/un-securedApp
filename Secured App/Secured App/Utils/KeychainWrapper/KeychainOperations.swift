//
//  KeychainOperations.swift
//  Secured App
//
//  Created by Mateusz Bąk on 11/10/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation
import Security

enum KeychainError: Error {
    case creatingError
    case operationError
}

protocol KeychainOperationsProtocol {
    func set(value: Data, account: String) throws
    func retreive(account: String) throws -> Data?
    func delete(account: String) throws
}

struct KeychainOperations: KeychainOperationsProtocol {
    
    func set(value: Data, account: String) throws {
        if try retreive(account: account) != nil {
            try update(value: value, account: account)
        } else {
            try add(value: value, account: account)
        }
    }
    
    func retreive(account: String) throws -> Data? {
        var result: AnyObject?
        
        let status = SecItemCopyMatching(
            [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: account,
                kSecAttrService: Configurator.keychainService,
                kSecReturnData: true
            ] as CFDictionary,
            &result
        )
        
        switch status {
        case errSecSuccess:
            return result as? Data
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainError.operationError
        }
    }
    
    func delete(account: String) throws {
        let status = SecItemDelete(
            [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: account,
                kSecAttrService: Configurator.keychainService
            ] as CFDictionary
        )
        
        guard status == errSecSuccess else { throw KeychainError.operationError }
    }
    
}

private extension KeychainOperations {
    func update(value: Data, account: String) throws {
        let status = SecItemUpdate(
            [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: account,
                kSecAttrService: Configurator.keychainService,
            ] as CFDictionary,
            [
                kSecValueData: value
            ] as CFDictionary
        )
        
        guard status == errSecSuccess else { throw KeychainError.operationError }
    }
    
    func add(value: Data, account: String) throws {
        let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, SecAccessControlCreateFlags.userPresence, nil)
        
        let status = SecItemAdd(
            [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: account,
                kSecAttrService: Configurator.keychainService,
                kSecAttrAccessControl: access as Any,
                kSecValueData: value
            ] as CFDictionary,
            nil
        )
        
        guard status == errSecSuccess else { throw KeychainError.creatingError }
    }
}
