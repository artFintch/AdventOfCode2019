//
//  main.swift
//  Sandbox
//
//  Created by Vyacheslav Khorkov on 01.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import Frog

let line = Frog("input.txt").readLine()!
    .components(separatedBy: ",")
    .compactMap(Int.init)

func getDigits(num: Int) -> [Int] {
    var digits: [Int] = []
    var num = num
    while num > 0 {
        let lastDigit = num % 10
        num /= 10
        digits.append(lastDigit)
    }
    return digits
}

func runProgram(_ nums: [Int], input: Int) -> Int {
    var input = input
    var dict: [Int: Int] = [:]
    for pair in nums.enumerated() {
        dict[pair.offset] = pair.element
    }

    var index = 0
    var rel = 0

    func indexForMode(_ mode: Int, i: Int, r: Int) -> Int {
        switch mode {
        case 0:
            return dict[i, default: 0]
        case 1:
            return i
        case 2:
            return r + dict[i, default: 0]
        default:
            fatalError()
        }
    }

    while true {
        var digits = getDigits(num: dict[index]!)

        let op: Int
        if digits.count == 1 {
            op = digits.removeFirst()
        } else {
            op = digits[1] * 10 + digits.removeFirst()
            digits.removeFirst()
        }

        let mode0 = digits.isEmpty ? 0 : digits.removeFirst()
        let mode1 = digits.isEmpty ? 0 : digits.removeFirst()
        let mode2 = digits.isEmpty ? 0 : digits.removeFirst()

        switch op {
        case 1:
            // +
            let arg1 = dict[indexForMode(mode0, i: index + 1, r: rel), default: 0]
            let arg2 = dict[indexForMode(mode1, i: index + 2, r: rel), default: 0]
            dict[indexForMode(mode2, i: index + 3, r: rel)] = arg1 + arg2
            index += 4

        case 2:
            // *
            let arg1 = dict[indexForMode(mode0, i: index + 1, r: rel), default: 0]
            let arg2 = dict[indexForMode(mode1, i: index + 2, r: rel), default: 0]
            dict[indexForMode(mode2, i: index + 3, r: rel)] = arg1 * arg2
            index += 4

        case 3:
            // in
            dict[indexForMode(mode0, i: index + 1, r: rel)] = input
            index += 2

        case 4:
            // out
            input = dict[indexForMode(mode0, i: index + 1, r: rel), default: 0]
            index += 2

        case 5:
            // jump-if-true
            let arg1 = dict[indexForMode(mode0, i: index + 1, r: rel), default: 0]
            let arg2 = dict[indexForMode(mode1, i: index + 2, r: rel), default: 0]
            index = (arg1 != 0) ? arg2 : index + 3

        case 6:
            // jump-if-false
            let arg1 = dict[indexForMode(mode0, i: index + 1, r: rel), default: 0]
            let arg2 = dict[indexForMode(mode1, i: index + 2, r: rel), default: 0]
            index = (arg1 == 0) ? arg2 : index + 3

        case 7:
            // less
            let arg1 = dict[indexForMode(mode0, i: index + 1, r: rel), default: 0]
            let arg2 = dict[indexForMode(mode1, i: index + 2, r: rel), default: 0]
            dict[indexForMode(mode2, i: index + 3, r: rel)] = (arg1 < arg2 ? 1 : 0)
            index += 4

        case 8:
            // equals
            let arg1 = dict[indexForMode(mode0, i: index + 1, r: rel), default: 0]
            let arg2 = dict[indexForMode(mode1, i: index + 2, r: rel), default: 0]
            dict[indexForMode(mode2, i: index + 3, r: rel)] = (arg1 == arg2 ? 1 : 0)
            index += 4

        case 9:
            // relative
            rel += dict[indexForMode(mode0, i: index + 1, r: rel), default: 0]
            index += 2

        case 99:
            return input

        default:
            fatalError()
        }
    }
}

// silver
assert(runProgram(line, input: 1) == 3241900951)

// gold
assert(runProgram(line, input: 2) == 83089)
