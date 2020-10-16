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
    
    static func isJailbroken() -> Bool {
        var results = Array<Bool>()
        
        results.append(URLSchemesToForbiddenAppsCheck())
        results.append(suspiciousFilesExistenceCheck())
        results.append(suspiciousFilesCanBeOpenedCheck())
        results.append(writeToRestrictedDirectoriesCheck())
        results.append(callForkPossibilityCheck())
        results.append(suspiciousItemsInSymbolicLinksCheck())
        results.append(DYLDcheck())
        
        print("Check If URL Schemes To Forbidden Apps Works: \(URLSchemesToForbiddenAppsCheck())")
        print("Check If Suspicious Files Existence: \(suspiciousFilesExistenceCheck())")
        print("Check If Suspicious Files Can Be Opened: \(suspiciousFilesCanBeOpenedCheck())")
        print("Check If Can Write To Restricted Directories: \(writeToRestrictedDirectoriesCheck())")
        print("Check Possibility of call Fork: \(callForkPossibilityCheck())")
        print("Check for suspicious items in symbolic links: \(suspiciousItemsInSymbolicLinksCheck())")
        print("Check DYLD: \(DYLDcheck())")
        
        return results.contains { $0 }
    }
}

private extension JailbreakDetectionService {
    // MARK: - Check If URL Schemes To Forbidden Apps Works
    static func URLSchemesToForbiddenAppsCheck() -> Bool {
        let urlSchemes = [
            "undecimus://",
            "cydia://",
            "sileo://",
            "zbra://"
        ]
        
        return urlSchemes.contains {
            guard let url = URL(string: $0) else { return false }
            return UIApplication.shared.canOpenURL(url)
        }
    }
    
    // MARK: - Check If Suspicious Files Existence
    static func suspiciousFilesExistenceCheck() -> Bool {
        let suspiciousFilesPaths = [
            "/usr/sbin/frida-server", // frida
            "/etc/apt/sources.list.d/electra.list", // electra
            "/etc/apt/sources.list.d/sileo.sources", // electra
            "/.bootstrapped_electra", // electra
            "/usr/lib/libjailbreak.dylib", // electra
            "/jb/lzma", // electra
            "/.cydia_no_stash", // unc0ver
            "/.installed_unc0ver", // unc0ver
            "/jb/offsets.plist", // unc0ver
            "/usr/share/jailbreak/injectme.plist", // unc0ver
            "/etc/apt/undecimus/undecimus.list", // unc0ver
            "/var/lib/dpkg/info/mobilesubstrate.md5sums", // unc0ver
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/jb/jailbreakd.plist", // unc0ver
            "/jb/amfid_payload.dylib", // unc0ver
            "/jb/libjailbreak.dylib", // unc0ver
            "/usr/libexec/cydia/firmware.sh",
            "/var/lib/cydia",
            "/etc/apt",
            "/private/var/lib/apt",
            "/private/var/Users/",
            "/var/log/apt",
            "/Applications/Cydia.app",
            "/private/var/stash",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/private/var/cache/apt/",
            "/private/var/log/syslog",
            "/private/var/tmp/cydia.log",
            "/Applications/Icy.app",
            "/Applications/MxTube.app",
            "/Applications/RockApp.app",
            "/Applications/blackra1n.app",
            "/Applications/SBSettings.app",
            "/Applications/FakeCarrier.app",
            "/Applications/WinterBoard.app",
            "/Applications/IntelliScreen.app",
            "/private/var/mobile/Library/SBSettings/Themes",
            "/Library/MobileSubstrate/CydiaSubstrate.dylib",
            "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
            "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
            "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
            "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/usr/libexec/ssh-keysign",
            "/bin/sh",
            "/etc/ssh/sshd_config",
            "/usr/libexec/sftp-server",
            "/usr/bin/ssh"
        ]
        
        return suspiciousFilesPaths.contains { FileManager.default.fileExists(atPath: $0) }
    }
    
    // MARK: - Check If Suspicious Files Can Be Opened
    static func suspiciousFilesCanBeOpenedCheck() -> Bool {
        let suspiciousFilesPaths = [
            "/.installed_unc0ver",
            "/.bootstrapped_electra",
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/etc/apt",
            "/var/log/apt",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/usr/bin/ssh"
        ]
        
        return suspiciousFilesPaths.contains { FileManager.default.isReadableFile(atPath: $0) }
    }
    
    // MARK: - Check If Can Write To Restricted Directories
    static func writeToRestrictedDirectoriesCheck() -> Bool {
        let restrictedDirectories = [
            "/",
            "/root/",
            "/private/",
            "/jb/"
        ]
        
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
        let suspiciousItemsSymbolicLinksPaths = [
            "/var/lib/undecimus/apt", // unc0ver
            "/Applications",
            "/Library/Ringtones",
            "/Library/Wallpaper",
            "/usr/arm-apple-darwin9",
            "/usr/include",
            "/usr/libexec",
            "/usr/share"
        ]
        
        return suspiciousItemsSymbolicLinksPaths.contains {
            let result = (try? FileManager.default.destinationOfSymbolicLink(atPath: $0)) ?? ""
            return result.isNotEmpty
        }
    }
    
    // MARK: - Check DYLD
    static func DYLDcheck() -> Bool {
        for libraryIndex in 0 ..< _dyld_image_count() {
            guard let loadedLibrary = String(validatingUTF8: _dyld_get_image_name(libraryIndex)) else { continue }
            
            let suspiciousLibraries = [
                "SubstrateLoader.dylib",
                "SSLKillSwitch2.dylib",
                "SSLKillSwitch.dylib",
                "MobileSubstrate.dylib",
                "TweakInject.dylib",
                "CydiaSubstrate",
                "cynject",
                "CustomWidgetIcons",
                "PreferenceLoader",
                "RocketBootstrap",
                "WeeLoader",
                "/.file" // HideJB (2.1.1) changes full paths of the suspicious libraries to "/.file"
            ]
            
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
