//
//  main.swift
//  Sandbox
//
//  Created by Vyacheslav Khorkov on 01.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import Frog

func readInput(from path: String) -> [Int] {
    return Frog(path).readLine()!
        .components(separatedBy: ",")
        .compactMap(Int.init)
}

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

func runProgram(_ nums: [Int], input: () -> Int, output: (Int) -> Void) {
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
            dict[indexForMode(mode0, i: index + 1, r: rel)] = input()
            index += 2

        case 4:
            // out
            output(dict[indexForMode(mode0, i: index + 1, r: rel), default: 0])
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
            return

        default:
            fatalError()
        }
    }
}

//
var input = readInput(from: "input.txt")

struct Point: Hashable { let x, y: Int }
var map: [Point: Int] = [:]

var xy: [Int] = []
runProgram(input, input: { () -> Int in
    fatalError()
}, output: {
    if xy.count == 2 {
        map[Point(x: xy[0], y: xy[1])] = $0
        xy.removeAll()
    } else {
        xy.append($0)
    }
})
let blocks = map.values.reduce(0) { $0 + ($1 == 2 ? 1 : 0) }
print(blocks, 258, blocks == 258)

// Gold
input[0] = 2
map = [:]
xy.removeAll()
var output = 0
runProgram(input, input: { () -> Int in
    let ball = map.first(where: { $1 == 4 })!.key
    let paddle = map.first(where: { $1 == 3 })!.key
    return ball.x - paddle.x
}, output: {
    if xy.count == 2 {
        if xy[0] == -1 && xy[1] == 0 {
            output = $0
        } else {
            map[Point(x: xy[0], y: xy[1])] = $0
        }
        xy.removeAll()
    } else {
        xy.append($0)
    }
})
print(map.values.reduce(0) { $0 + ($1 == 2 ? 1 : 0) })
print(output, 12765, output == 12765)
