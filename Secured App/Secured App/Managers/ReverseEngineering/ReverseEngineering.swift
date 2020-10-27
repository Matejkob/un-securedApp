//
//  ReverseEngineering.swift
//  Secured App
//
//  Created by Mateusz Bąk on 27/10/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation
import MachO.dyld

final class ReverseEngineeringToolsChecker {
    
    private static let o = Obfuscator()

    static func isReverseEngineered() -> Bool {
        DYLDcheck() || suspiciousFilesExistenceCheck() || canOpenPortCheck()
    }
}

private extension ReverseEngineeringToolsChecker {
    // MARK: - Check DYLD
    static func DYLDcheck() -> Bool {
        for libraryIndex in 0 ..< _dyld_image_count() {
            guard let loadedLibrary = String(validatingUTF8: _dyld_get_image_name(libraryIndex)) else { continue }
            
            let key: [UInt8] = [18, 5, 18, 55, 17, 30, 4, 19, 4, 56, 10, 47, 55, 42, 16, 68, 1, 26, 24, 40, 18, 75, 23, 54, 32, 46, 14, 13, 24, 54, 57, 58, 59, 1, 2, 87, 77, 16, 56, 28, 25, 38, 94, 63, 54, 43, 42, 29, 9, 34, 0, 56, 11, 30, 6, 11, 90, 37, 9, 28, 45, 7, 87, 40, 8, 3, 29, 9, 43, 0, 58, 0, 25, 17, 17, 21, 53, 21, 94, 32, 28, 0, 12, 5, 90, 32, 18, 43, 50, 36, 43, 4, 15, 6, 23, 53, 94, 20, 61, 9, 5, 7, 92, 34, 13, 1, 39, 50, 28, 23, 8, 22, 23, 6, 32, 4, 21, 127, 6, 21, 11, 13, 4, 23, 17, 117, 16, 58, 17, 30, 10, 14, 35, 40, 20, 23, 33, 17, 37, 6, 8, 15, 7, 94, 30, 33, 42, 4, 15, 23, 6, 26, 34, 21, 60, 43, 4, 8, 0, 21, 90, 38, 10, 45, 56, 42, 22, 40, 10, 12, 0, 50, 4, 2, 37, 21, 87, 50, 2, 4, 56, 10, 47, 55, 42, 16, 81, 74, 77, 18, 40, 28, 21]
            let suspiciousLibrariesString = o.reveal(key: key)
            let suspiciousLibraries = suspiciousLibrariesString.components(separatedBy: ";")
            
            if suspiciousLibraries.contains(where: { loadedLibrary.lowercased().contains($0.lowercased()) }) {
                return true
            }
        }
        return false
    }

    // MARK: - Check If Suspicious Files Existence
    static func suspiciousFilesExistenceCheck() -> Bool {
        let suspiciousFilesPaths = [
            "/usr/sbin/frida-server"
        ]
        
        return suspiciousFilesPaths.contains { FileManager.default.fileExists(atPath: $0) }
    }

    // MARK: - Check If Can Open Port
    static func canOpenPortCheck() -> Bool {
        let ports = [
            27042, // default Frida
            4444 // default Needle
        ]

        return ports.contains { canOpenLocalConnection(port: $0) }
    }

     static func canOpenLocalConnection(port: Int) -> Bool {
        func swapBytesIfNeeded(port: in_port_t) -> in_port_t {
            let littleEndian = Int(OSHostByteOrder()) == OSLittleEndian
            return littleEndian ? _OSSwapInt16(port) : port
        }

        var serverAddress = sockaddr_in()
        serverAddress.sin_family = sa_family_t(AF_INET)
        serverAddress.sin_addr.s_addr = inet_addr("127.0.0.1")
        serverAddress.sin_port = swapBytesIfNeeded(port: in_port_t(port))
        let sock = socket(AF_INET, SOCK_STREAM, 0)

        let result = withUnsafePointer(to: &serverAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                connect(sock, $0, socklen_t(MemoryLayout<sockaddr_in>.stride))
            }
        }

        return result != -1
    }
}
