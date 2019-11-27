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

    // TODO: Add read soluton for 2019
    func silver(_ input: [Int]) -> Int {
        return input.reduce(0, +)
    }

    func gold(_ input: [Int]) -> Int {
        var (frequency, step) = (0, 0)
        var seen: Set<Int> = []
        while seen.insert(frequency).inserted {
            frequency += input[step % input.count]
            step += 1
        }
        return frequency
    }
}
