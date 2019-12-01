//
//  day01Tests.swift
//  Tests
//
//  Created by v.khorkov on 27.11.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import XCTest
import AdventCode

class Day01Tests: XCTestCase {

    private let solution = TestSolution<Day01>(
        silverAnswer: 3262991,
        goldAnswer: 4891620
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
