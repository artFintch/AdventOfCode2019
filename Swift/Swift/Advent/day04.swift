//
//  day04.swift
//  Tests
//
//  Created by Vyacheslav Khorkov on 05.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import AdventCode
import Frog

struct Day04: Solution {

    func readInput(from path: String) ->  Range<Int> {
        return 197487..<673251
    }

    func silver(_ range: Range<Int>) -> Int {
        return range.reduce(0) { $0 + (isValidPass($1, uniqueCount: { $0 > 1 }) ? 1 : 0) }
    }

    func gold(_ range: Range<Int>) -> Int {
        return range.reduce(0) { $0 + (isValidPass($1, uniqueCount: { $0 == 2 }) ? 1 : 0) }
    }

    private func isValidPass(_ pass: Int, uniqueCount: (Int) -> Bool) -> Bool {
        let string = String(pass)
        guard String(string.sorted()) == string else { return false }

        let counts: [Character: Int] = string.reduce(into: [:]) {
            $0[$1, default: 0] += 1
        }
        return counts.values.contains(where: uniqueCount)
    }
}
