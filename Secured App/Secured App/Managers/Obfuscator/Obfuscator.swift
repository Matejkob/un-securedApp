//
//  Obfuscator.swift
//  Secured App
//
//  Created by Mateusz Bąk on 27/10/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

final class Obfuscator {
    
    private var salt: String
    
    init(with salt: String) {
        self.salt = salt
    }
    
    convenience init() {
        self.init(with: "\(String(describing: AppDelegate.self))\(String(describing: NSObject.self))")
    }
    
    func bytesByObfuscatingString(string: String) -> [UInt8] {
        let text = [UInt8](string.utf8)
        let cipher = [UInt8](salt.utf8)
        let length = cipher.count
        
        var encrypted = [UInt8]()
        
        for t in text.enumerated() {
            encrypted.append(t.element ^ cipher[t.offset % length])
        }
        
        return encrypted
    }
    
    func reveal(key: [UInt8]) -> String {
        let cipher = [UInt8](self.salt.utf8)
        let length = cipher.count
        
        var decrypted = [UInt8]()
        
        for k in key.enumerated() {
            decrypted.append(k.element ^ cipher[k.offset % length])
        }
        
        return String(bytes: decrypted, encoding: .utf8)!
    }
}
