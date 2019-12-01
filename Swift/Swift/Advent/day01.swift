//
//  day01.swift
//  Tests
//
//  Created by v.khorkov on 27.11.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import AdventCode
import Frog

struct Day01: Solution {

    func readInput(from path: String) -> [Int] {
        return Frog(path).readLines().compactMap(Int.init)
    }

    func silver(_ input: [Int]) -> Int {
        return input.reduce(0) { $0 + $1 / 3 - 2 }
    }

    func gold(_ input: [Int]) -> Int {
        return input.reduce(0) {
            var number = $1
            var sum = 0
            while (number / 3 - 2) > 0 {
                number = number / 3 - 2
                sum += number
            }
            return $0 + sum
        }
    }
}
