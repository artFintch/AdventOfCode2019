//
//  Day08Tests.swift
//  Tests
//
//  Created by v.khorkov on 08.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import XCTest
import AdventCode

final class Day08Tests: XCTestCase {

    private let solution = TestSolution<Day08>(
        silverAnswer: 1224,
        goldAnswer: "EBZUR"
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
