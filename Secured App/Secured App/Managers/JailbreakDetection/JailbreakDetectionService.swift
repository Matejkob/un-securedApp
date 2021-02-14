//
//  JailbreakDetectionService.swift
//  Secured App
//
//  Created by Mateusz Bąk on 14/10/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit
import MachO.dyld

struct JailbreakDetectionService {
    
    private static let o = Obfuscator()
    
    public static func isJailbroken() -> Bool {
        var results = Array<Bool>()
        
        results.append(URLSchemesToForbiddenAppsCheck())
        results.append(suspiciousFilesExistenceCheck())
        results.append(suspiciousFilesCanBeOpenedCheck())
        results.append(writeToRestrictedDirectoriesCheck())
        results.append(callForkPossibilityCheck())
        results.append(suspiciousItemsInSymbolicLinksCheck())
        results.append(DYLDcheck())
    
        return results.contains { $0 }
    }
}

private extension JailbreakDetectionService {
    // MARK: - Check If URL Schemes To Forbidden Apps Works
    static func URLSchemesToForbiddenAppsCheck() -> Bool {
        let key: [UInt8] = [52, 30, 20, 33, 6, 5, 8, 18, 18, 78, 74, 97, 104, 44, 27, 14, 12, 2, 78, 110, 95, 75, 55, 12, 0, 0, 8, 91, 91, 74, 117, 41, 45, 16, 11, 95, 76, 91]
        let urlSchemesString = o.reveal(key: key)
        let urlSchemes = urlSchemesString.components(separatedBy: ";")
                
        return urlSchemes.contains {
            guard let url = URL(string: $0) else { return false }
            return UIApplication.shared.canOpenURL(url)
        }
    }
    
    // MARK: - Check If Suspicious Files Existence
    static func suspiciousFilesExistenceCheck() -> Bool {
        let key: [UInt8] = [110, 5, 3, 54, 74, 31, 7, 14, 15, 91, 3, 60, 58, 43, 3, 71, 22, 6, 6, 55, 21, 2, 127, 74, 9, 17, 4, 78, 21, 21, 58, 124, 60, 13, 31, 23, 0, 17, 50, 94, 28, 45, 22, 24, 75, 3, 78, 17, 9, 43, 48, 59, 16, 11, 75, 15, 29, 50, 4, 75, 107, 0, 24, 6, 72, 0, 4, 17, 97, 32, 32, 23, 24, 6, 6, 7, 111, 28, 25, 55, 17, 66, 1, 72, 18, 29, 9, 43, 60, 97, 17, 5, 16, 17, 23, 36, 3, 75, 107, 75, 14, 10, 8, 21, 7, 17, 60, 50, 63, 18, 15, 1, 60, 17, 45, 21, 19, 48, 23, 13, 94, 72, 20, 7, 23, 97, 63, 38, 0, 69, 9, 10, 22, 43, 17, 25, 40, 7, 30, 0, 6, 10, 90, 1, 55, 63, 38, 0, 81, 74, 9, 22, 110, 28, 10, 41, 4, 87, 74, 73, 2, 13, 1, 39, 50, 16, 12, 5, 58, 16, 0, 32, 3, 24, 127, 74, 66, 12, 9, 18, 0, 4, 34, 63, 42, 6, 53, 16, 13, 23, 113, 6, 21, 54, 94, 67, 15, 5, 78, 27, 3, 40, 32, 42, 22, 25, 75, 19, 24, 40, 3, 4, 127, 74, 25, 22, 21, 78, 7, 13, 47, 33, 42, 77, 0, 4, 10, 24, 35, 2, 21, 37, 14, 67, 12, 9, 11, 17, 6, 58, 62, 42, 76, 26, 9, 10, 7, 53, 75, 95, 33, 17, 15, 74, 6, 17, 0, 74, 59, 61, 43, 7, 9, 12, 14, 1, 50, 95, 5, 42, 1, 9, 6, 14, 12, 1, 22, 96, 63, 38, 17, 30, 94, 76, 2, 32, 2, 95, 40, 12, 14, 74, 3, 17, 31, 2, 97, 58, 33, 4, 5, 74, 14, 27, 35, 25, 28, 33, 22, 25, 7, 20, 21, 6, 4, 58, 54, 97, 15, 14, 80, 16, 1, 44, 3, 75, 107, 41, 5, 7, 21, 0, 6, 28, 97, 30, 32, 0, 3, 9, 6, 39, 52, 18, 3, 48, 23, 13, 17, 2, 78, 57, 10, 44, 58, 35, 7, 57, 16, 1, 7, 53, 2, 17, 48, 0, 66, 1, 30, 13, 29, 7, 117, 124, 37, 0, 69, 15, 2, 29, 45, 18, 2, 33, 4, 7, 1, 73, 17, 24, 12, 61, 39, 116, 77, 0, 7, 76, 21, 44, 22, 25, 32, 58, 28, 4, 30, 13, 27, 4, 42, 125, 43, 27, 6, 12, 1, 79, 110, 26, 18, 107, 9, 5, 7, 13, 0, 29, 9, 44, 33, 42, 3, 1, 75, 7, 13, 45, 25, 18, 127, 74, 25, 22, 21, 78, 24, 12, 44, 54, 55, 7, 9, 74, 0, 13, 37, 25, 17, 107, 3, 5, 23, 10, 22, 21, 23, 43, 125, 60, 10, 81, 74, 21, 21, 51, 95, 28, 45, 7, 67, 6, 30, 5, 29, 4, 117, 124, 42, 22, 9, 74, 2, 4, 53, 75, 95, 52, 23, 5, 19, 6, 21, 17, 74, 56, 50, 61, 77, 6, 12, 1, 91, 32, 0, 4, 127, 74, 28, 23, 14, 23, 21, 17, 43, 124, 57, 3, 24, 74, 54, 7, 36, 2, 3, 107, 94, 67, 19, 6, 19, 91, 9, 33, 52, 96, 3, 26, 17, 88, 91, 0, 0, 0, 40, 12, 15, 4, 19, 8, 27, 11, 61, 124, 12, 27, 14, 12, 2, 90, 32, 0, 0, 127, 74, 28, 23, 14, 23, 21, 17, 43, 124, 57, 3, 24, 74, 16, 0, 32, 3, 24, 127, 74, 28, 23, 14, 23, 21, 17, 43, 124, 57, 3, 24, 74, 15, 29, 35, 95, 17, 52, 17, 67, 94, 72, 17, 6, 12, 56, 50, 59, 7, 69, 19, 2, 6, 110, 28, 25, 38, 74, 15, 28, 3, 8, 21, 94, 97, 35, 61, 11, 28, 4, 23, 17, 110, 6, 17, 54, 74, 15, 4, 4, 9, 17, 74, 47, 35, 59, 77, 81, 74, 19, 6, 40, 6, 17, 48, 0, 67, 19, 6, 19, 91, 9, 33, 52, 96, 17, 19, 22, 15, 27, 38, 75, 95, 52, 23, 5, 19, 6, 21, 17, 74, 56, 50, 61, 77, 30, 8, 19, 91, 34, 9, 20, 45, 4, 66, 9, 8, 6, 79, 74, 15, 35, 63, 14, 3, 6, 2, 0, 40, 31, 30, 55, 74, 37, 6, 30, 79, 21, 21, 62, 104, 96, 35, 26, 21, 15, 29, 34, 17, 4, 45, 10, 2, 22, 72, 44, 12, 49, 59, 49, 42, 76, 11, 21, 19, 79, 110, 49, 0, 52, 9, 5, 6, 6, 21, 29, 10, 32, 32, 96, 48, 5, 6, 8, 53, 49, 0, 94, 37, 21, 28, 94, 72, 32, 4, 21, 34, 58, 44, 3, 30, 12, 12, 26, 50, 95, 18, 40, 4, 15, 14, 21, 0, 69, 11, 96, 50, 63, 18, 81, 74, 34, 4, 49, 28, 25, 39, 4, 24, 12, 8, 15, 7, 74, 29, 17, 28, 7, 30, 17, 10, 26, 38, 3, 94, 37, 21, 28, 94, 72, 32, 4, 21, 34, 58, 44, 3, 30, 12, 12, 26, 50, 95, 54, 37, 14, 9, 38, 6, 19, 6, 12, 43, 33, 97, 3, 26, 21, 88, 91, 0, 0, 0, 40, 12, 15, 4, 19, 8, 27, 11, 61, 124, 24, 11, 4, 17, 6, 6, 3, 31, 17, 54, 1, 66, 4, 23, 17, 79, 74, 15, 35, 63, 14, 3, 6, 2, 0, 40, 31, 30, 55, 74, 37, 11, 19, 4, 24, 9, 39, 0, 44, 16, 15, 0, 13, 90, 32, 0, 0, 127, 74, 28, 23, 14, 23, 21, 17, 43, 124, 57, 3, 24, 74, 14, 27, 35, 25, 28, 33, 74, 32, 12, 5, 19, 21, 23, 55, 124, 28, 32, 57, 0, 23, 0, 40, 30, 23, 55, 74, 56, 13, 2, 12, 17, 22, 117, 124, 3, 11, 8, 23, 2, 6, 56, 95, 61, 43, 7, 5, 9, 2, 50, 1, 7, 61, 39, 61, 3, 30, 0, 76, 55, 56, 20, 25, 37, 54, 25, 7, 20, 21, 6, 4, 58, 54, 97, 6, 19, 9, 10, 22, 122, 95, 35, 61, 22, 24, 0, 10, 78, 56, 12, 44, 33, 46, 16, 19, 74, 47, 21, 52, 30, 19, 44, 33, 13, 0, 10, 14, 26, 22, 97, 48, 32, 15, 68, 12, 8, 17, 56, 94, 18, 38, 10, 24, 75, 23, 13, 29, 22, 58, 104, 96, 46, 3, 7, 17, 21, 51, 9, 95, 9, 10, 14, 12, 11, 4, 39, 16, 44, 32, 59, 16, 11, 17, 6, 91, 5, 9, 30, 37, 8, 5, 6, 43, 8, 22, 23, 47, 33, 38, 7, 25, 74, 53, 17, 36, 30, 19, 61, 75, 28, 9, 14, 18, 0, 94, 97, 31, 38, 0, 24, 4, 17, 13, 110, 61, 31, 38, 12, 0, 0, 52, 20, 22, 22, 58, 33, 46, 22, 15, 74, 39, 13, 47, 17, 29, 45, 6, 32, 12, 5, 19, 21, 23, 39, 54, 60, 77, 38, 12, 21, 17, 2, 28, 31, 39, 14, 66, 21, 11, 8, 7, 17, 117, 124, 28, 27, 25, 17, 6, 25, 110, 60, 25, 38, 23, 13, 23, 30, 78, 56, 4, 59, 61, 44, 10, 46, 4, 6, 25, 46, 30, 3, 107, 6, 3, 8, 73, 18, 21, 16, 60, 58, 36, 76, 41, 28, 7, 29, 32, 94, 35, 48, 4, 30, 17, 18, 17, 90, 21, 34, 58, 60, 22, 81, 74, 1, 29, 47, 95, 18, 37, 22, 4, 94, 72, 20, 7, 23, 97, 32, 45, 11, 4, 74, 16, 7, 41, 20, 75, 107, 16, 31, 23, 72, 13, 29, 7, 43, 43, 42, 1, 69, 22, 16, 28, 108, 27, 21, 61, 22, 5, 2, 9, 90, 91, 7, 39, 61, 96, 17, 2, 94, 76, 17, 53, 19, 95, 55, 22, 4, 74, 20, 18, 28, 1, 17, 48, 32, 12, 12, 12, 4, 79, 110, 5, 3, 54, 74, 0, 12, 5, 4, 12, 0, 45, 124, 60, 4, 30, 21, 78, 7, 36, 2, 6, 33, 23, 87, 74, 18, 18, 6, 74, 44, 58, 33, 77, 25, 22, 11]
        let suspiciousFilesPathsString = o.reveal(key: key)
        let suspiciousFilesPaths = suspiciousFilesPathsString.components(separatedBy: ";")
        
        return suspiciousFilesPaths.contains { FileManager.default.fileExists(atPath: $0) }
    }
    
    // MARK: - Check If Suspicious Files Can Be Opened
    static func suspiciousFilesCanBeOpenedCheck() -> Bool {
        let key: [UInt8] = [110, 94, 25, 42, 22, 24, 4, 11, 13, 17, 1, 17, 38, 33, 1, 90, 19, 6, 6, 122, 95, 94, 38, 10, 3, 17, 20, 21, 6, 4, 62, 35, 42, 6, 53, 0, 15, 17, 34, 4, 2, 37, 94, 67, 36, 23, 17, 24, 12, 45, 50, 59, 11, 5, 11, 16, 91, 2, 9, 20, 45, 4, 66, 4, 23, 17, 79, 74, 2, 58, 45, 16, 11, 23, 26, 91, 12, 31, 18, 45, 9, 9, 54, 18, 3, 7, 17, 60, 50, 59, 7, 69, 40, 12, 22, 40, 28, 21, 23, 16, 14, 22, 19, 19, 21, 17, 43, 125, 43, 27, 6, 12, 1, 79, 110, 21, 4, 39, 74, 13, 21, 19, 90, 91, 19, 47, 33, 96, 14, 5, 2, 76, 21, 49, 4, 75, 107, 7, 5, 11, 72, 3, 21, 22, 38, 104, 96, 23, 25, 23, 76, 7, 35, 25, 30, 107, 22, 31, 13, 3, 90, 91, 16, 61, 33, 96, 0, 3, 11, 76, 7, 50, 24]
        let suspiciousFilesPathsString = o.reveal(key: key)
        let suspiciousFilesPaths = suspiciousFilesPathsString.components(separatedBy: ";")
        
        return suspiciousFilesPaths.contains { FileManager.default.isReadableFile(atPath: $0) }
    }
    
    // MARK: - Check If Can Write To Restricted Directories
    static func writeToRestrictedDirectoriesCheck() -> Bool {
        let key: [UInt8] = [110, 75, 95, 54, 10, 3, 17, 72, 90, 91, 21, 60, 58, 57, 3, 30, 0, 76, 79, 110, 26, 18, 107]
        let restrictedDirectoriesString = o.reveal(key: key)
        let restrictedDirectories = restrictedDirectoriesString.components(separatedBy: ";")
        
        return restrictedDirectories.contains {
            let newFileInrestrictedDirectories = $0 + String.random(length: 16)
            let writeResult: ()? = try? "Test Jailbreak".write(toFile: newFileInrestrictedDirectories, atomically: true, encoding: .utf8)
            let canWriteToRestrictedDirectories = writeResult != nil
             
            try? FileManager.default.removeItem(atPath: newFileInrestrictedDirectories)
            
            return canWriteToRestrictedDirectories
        }
    }
    
    // MARK: - Check Possibility of call Fork
    static func callForkPossibilityCheck() -> Bool {
        let RTLD_DEFAULT = UnsafeMutableRawPointer(bitPattern: -2)
        let forkPtr = dlsym(RTLD_DEFAULT, "fork")
        typealias ForkType = @convention(c) () -> Int32
        let fork = unsafeBitCast(forkPtr, to: ForkType.self)
        let forkResult = fork()
        
        switch forkResult {
        case -1:
            return false
        case 0:
            return true
        default:
            kill(forkResult, SIGTERM)
            return true
        }
    }
    
    // MARK: - Check for suspicious items in symbolic links
    static func suspiciousItemsInSymbolicLinksCheck() -> Bool {
        let key: [UInt8] = [110, 6, 17, 54, 74, 0, 12, 5, 78, 1, 11, 42, 54, 44, 11, 7, 16, 16, 91, 32, 0, 4, 127, 74, 45, 21, 23, 13, 29, 6, 47, 39, 38, 13, 4, 22, 88, 91, 13, 25, 18, 54, 4, 30, 28, 72, 51, 29, 11, 41, 39, 32, 12, 15, 22, 88, 91, 13, 25, 18, 54, 4, 30, 28, 72, 54, 21, 9, 34, 35, 46, 18, 15, 23, 88, 91, 52, 3, 2, 107, 4, 30, 8, 74, 0, 4, 21, 34, 54, 98, 6, 11, 23, 20, 29, 47, 73, 75, 107, 16, 31, 23, 72, 8, 26, 6, 34, 38, 43, 7, 81, 74, 22, 7, 51, 95, 28, 45, 7, 9, 29, 2, 2, 79, 74, 59, 32, 61, 77, 25, 13, 2, 6, 36]
        let suspiciousItemsSymbolicLinksPathsString = o.reveal(key: key)
        let suspiciousItemsSymbolicLinksPaths = suspiciousItemsSymbolicLinksPathsString.components(separatedBy: ";")
        
        return suspiciousItemsSymbolicLinksPaths.contains {
            let result = (try? FileManager.default.destinationOfSymbolicLink(atPath: $0)) ?? ""
            return result.isNotEmpty
        }
    }
    
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
}

private extension String {
    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((1 ... length).map { _ in (letters.randomElement()!) })
    }
}

private extension Swift.Collection {
    var isNotEmpty: Bool {
        !self.isEmpty
    }
}
