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

enum Direction { case left, right, up, down }
struct Point: Hashable { let x, y: Int }
var robotDirection: Direction = .up
var robotPosition = Point(x: 0, y: 0)

let input = readInput(from: "input.txt")
var map: [Point: Int] = [:]
var set: Set<Point> = []

func moveLeft(_ from: Direction) -> Direction {
    let directions: [Direction] = [.up, .right, .down, .left]
    let first = directions.firstIndex(of: from)!
    if first == 0 {
        return directions.last!
    }
    return directions[first - 1]
}

func moveRight(_ from: Direction) -> Direction {
    let directions: [Direction] = [.up, .right, .down, .left]
    let first = directions.firstIndex(of: from)!
    if first + 1 == directions.count {
        return directions.first!
    }
    return directions[first + 1]
}

func move(_ from: Point, _ direction: Direction) -> Point {
    switch direction {
    case .up:
        return Point(x: from.x, y: from.y + 1)
    case .down:
        return Point(x: from.x, y: from.y - 1)
    case .left:
        return Point(x: from.x - 1, y: from.y)
    case .right:
        return Point(x: from.x + 1, y: from.y)
    }
}

var oddOutput = true
runProgram(input, input: { () -> Int in
    return map[robotPosition, default: 1]
}, output: {
    if oddOutput {
        map[robotPosition] = $0
        set.insert(robotPosition)
    } else {
        robotDirection = ($0 == 0) ? moveLeft(robotDirection) : moveRight(robotDirection)
        robotPosition = move(robotPosition, robotDirection)
    }
    oddOutput.toggle()
})
print(set.count)

var minX = map.keys.min(by: { $0.x < $1.x })!.x
var minY = map.keys.min(by: { $0.y < $1.y })!.y

let maxX = map.keys.max(by: { $0.x < $1.x })!.x - minX
let maxY = map.keys.max(by: { $0.y < $1.y })!.y - minY

var a: [[String]] = Array(repeating: Array(repeating: ".", count: maxX - minX + 1), count: maxY - minY)
for (p, v) in map {
    a[p.y - minY][p.x - minX] = (v == 1) ? "O" : "."
}
a.forEach {
    print($0.joined())
}
// EGHKGJER
