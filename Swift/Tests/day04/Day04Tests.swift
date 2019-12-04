//
//  Day04Tests.swift
//  Tests
//
//  Created by v.khorkov on 05.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import XCTest
import AdventCode

final class Day04Tests: XCTestCase {

    private let solution = TestSolution<Day04>(
        silverAnswer: 1640,
        goldAnswer: 1126
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
