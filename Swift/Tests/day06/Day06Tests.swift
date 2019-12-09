//
//  Day06Tests.swift
//  Tests
//
//  Created by v.khorkov on 09.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import XCTest
import AdventCode

final class Day06Tests: XCTestCase {

    private let solution = TestSolution<Day06>(
        silverAnswer: 224901,
        goldAnswer: 334
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
