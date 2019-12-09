//
//  Day05Tests.swift
//  Tests
//
//  Created by v.khorkov on 09.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import XCTest
import AdventCode

final class Day05Tests: XCTestCase {

    private let solution = TestSolution<Day05>(
        silverAnswer: 12440243,
        goldAnswer: 15486302
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
