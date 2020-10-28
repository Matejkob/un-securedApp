//
//  RuntimeHook.swift
//  Secured App
//
//  Created by Mateusz Bąk on 27/10/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation
import MachO

final class RuntimeHook {

    static private let swiftOnceDenyFishHooK: Void = {
        #if arch(arm64)
        FishHookChecker.denyFishHook("dladdr")
        #endif
    }()

    static func amIRuntimeHook(dyldWhiteList: [String], detectionClass: AnyClass, selector: Selector, isClassMethod: Bool) -> Bool {
        var method: Method?
        if isClassMethod {
            method = class_getClassMethod(detectionClass, selector)
        } else {
            method = class_getInstanceMethod(detectionClass, selector)
        }

        if method == nil {
            // method not found
            return true
        }

        let imp = method_getImplementation(method!)
        var info = Dl_info()

        _ = swiftOnceDenyFishHooK

        // dladdr will look through vm range of allImages for vm range of an Image that contains pointer of method and return info of the Image
        if dladdr(UnsafeRawPointer(imp), &info) != 1 {
            return false
        }

        let impDyldPath = String(cString: info.dli_fname).lowercased()

        // at system framework
        if impDyldPath.contains("/System/Library".lowercased()) {
            return false
        }

        // at binary of app
        let binaryPath = String(cString: _dyld_get_image_name(0)).lowercased()
        if impDyldPath.contains(binaryPath) {
            return false
        }

        // at whiteList
        if let impFramework = impDyldPath.components(separatedBy: "/").last {
            return !dyldWhiteList.map({ $0.lowercased() }).contains(impFramework)
        }

        // at injected framework
        return true
    }
}
