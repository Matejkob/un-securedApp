//
//  EmulatorDetectionService.swift
//  Secured App
//
//  Created by Mateusz Bąk on 14/10/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

struct EmulatorDetectionService {
    
    static func isEmulator() -> Bool {
        isRuntime() || isCompile()
    }
}

private extension EmulatorDetectionService {
    static func isRuntime() -> Bool {
        ProcessInfo().environment["SIMULATOR_DEVICE_NAME"] != nil
    }
    
    static func isCompile() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}
