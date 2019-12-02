//
//  Day02Tests.swift
//  Tests
//
//  Created by v.khorkov on 02.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import XCTest
import AdventCode

final class Day02Tests: XCTestCase {

    private let solution = TestSolution<Day02>(
        silverAnswer: 3409710,
        goldAnswer: 7912
    )

    func testSilver() {
        measure {
            XCTAssert(solution.checkSilver())
        }
    }

    func testGold() {
        measure {
            XCTAssert(solution.checkGold())
        }
    }
}
