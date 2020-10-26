//
//  Secured_App_Unit_Tests.swift
//  Secured App Unit Tests
//
//  Created by Mateusz Bąk on 17/10/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import XCTest
@testable import Secured_App

final class Secured_App_Unit_Tests: XCTestCase {
    
    func test_JailbreakDetectionServicePerformance() {
        measure {
            let _ = JailbreakDetectionService.isJailbroken()
        }
    }

}
