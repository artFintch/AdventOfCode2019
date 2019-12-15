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

struct Program {

    enum State {
        case stop, input, output
    }
    private var state: State = .stop

    private var dict: [Int: Int] = [:]
    private var index = 0
    private var rel = 0

    private var output = 0
    private var inputMode = 0

    init(nums: [Int]) {
        for pair in nums.enumerated() {
            dict[pair.offset] = pair.element
        }
    }

    mutating func run() {
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
                inputMode = mode0
                state = .input
                // wait input
                return

            case 4:
                // out
                output = dict[indexForMode(mode0, i: index + 1, r: rel), default: 0]
                index += 2
                state = .output
                // wait continue
                return

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

    mutating func input(_ input: Int) {
        guard state == .input else { fatalError() }
        dict[indexForMode(inputMode, i: index + 1, r: rel)] = input
        index += 2
    }

    func readOutput() -> Int {
        guard state == .output else { fatalError() }
        return output
    }

    private func indexForMode(_ mode: Int, i: Int, r: Int) -> Int {
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
}

struct Point: Hashable { let x, y: Int }
func +(lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func dijkstra(begin: Point,
              droid: Program) -> (finish: Point?, map: [Point: Int], path: [Point: Int]) {
    var map: [Point: Int] = [:]
    var path = [begin: 0]
    var queue: [(Point, Program)] = [(begin, droid)]
    var finish: Point?
    while !queue.isEmpty {
        let (first, originDroid) = queue.removeFirst()
        // north (1), south (2), west (3), and east (4)
        let points = [first + Point(x: 0, y: 1),
                      first + Point(x: 0, y: -1),
                      first + Point(x: -1, y: 0),
                      first + Point(x: 1, y: 0)]
        for direction in [1, 2, 3, 4] {
            let newPosition = points[direction - 1]
            if map[newPosition, default: -1] == 0 { continue }

            var droid = originDroid
            droid.input(direction)
            droid.run()
            let output = droid.readOutput()
            droid.run()
            map[newPosition] = output

            switch output {
            case 0:
                continue
            case 1:
                break
            case 2:
                finish = newPosition
            default:
                fatalError()
            }

            if path[first]! + 1 < path[newPosition, default: 999] {
                path[newPosition] = path[first]! + 1
                queue.append((newPosition, droid))
            }
        }
    }

    return (finish, map, path)
}

//
let input = readInput(from: "input.txt")
let begin = Point(x: 0, y: 0)
var droid = Program(nums: input)
droid.run()
let result = dijkstra(begin: begin, droid: droid)
print(result.path[result.finish!]!)

func dijkstraVanilla(begin: Point, map: [Point: Int]) -> [Point: Int] {
    var queue = [begin]
    var path: [Point: Int] = [begin: 0]
    while !queue.isEmpty {
        let first = queue.removeFirst()
        let points = [first + Point(x: 0, y: 1),
                      first + Point(x: 0, y: -1),
                      first + Point(x: -1, y: 0),
                      first + Point(x: 1, y: 0)]
        for point in points {
            if map[point] == 0 { continue }
            if path[first]! + 1 < path[point, default: 999] {
                path[point] = path[first]! + 1
                queue.append(point)
            }
        }
    }
    return path
}
let path = dijkstraVanilla(begin: result.finish!, map: result.map)
print(path.values.max()!)
