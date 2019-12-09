//
//  Day09Tests.swift
//  Tests
//
//  Created by v.khorkov on 09.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import XCTest
import AdventCode

final class Day09Tests: XCTestCase {

    private let solution = TestSolution<Day09>(
        silverAnswer: 3241900951,
        goldAnswer: 83089
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
