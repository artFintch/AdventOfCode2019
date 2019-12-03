//
//  day03.swift
//  Tests
//
//  Created by Vyacheslav Khorkov on 04.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import AdventCode
import Frog

struct Day03: Solution {

    func readInput(from path: String) -> [[String]] {
        return Frog(path).readLines().map {
            $0.components(separatedBy: ",")
        }
    }

    func silver(_ lines: [[String]]) -> Int {
        let cross = solution(lines).cross
        return cross.map { Swift.abs($0.x) + Swift.abs($0.y) }.min()!
    }

    func gold(_ lines: [[String]]) -> Int {
        let (cross, steps) = solution(lines)
        return cross.map { steps[0][$0]! + steps[1][$0]! }.min()!
    }

    private func solution(_ lines: [[String]]) -> (cross: Set<Point>, steps: [[Point: Int]]) {
        var stepsCount = 0
        var id = 0
        var anotherId = 0
        var cross: Set<Point> = []
        var points: [Set<Point>] = [[], []]
        var steps: [[Point: Int]] = [[:], [:]]
        func block(_ point: Point) {
            stepsCount += 1
            points[id].insert(point)
            steps[id][point] = stepsCount
            if points[anotherId].contains(point) {
                cross.insert(point)
            }
        }

        for line in lines {
            stepsCount = 0
            anotherId = Swift.abs(id - 1)
            var current = Point(x: 0, y: 0)
            for step in line {
                let direction = step.first!
                let distance = Int(step.dropFirst())!
                switch direction {
                case "U":
                    ((current.y + 1)...(current.y + distance)).forEach {
                        block(Point(x: current.x, y: $0))
                    }
                    current.y += distance

                case "D":
                    ((current.y - distance)..<current.y).reversed().forEach {
                        block(Point(x: current.x, y: $0))
                    }
                    current.y -= distance

                case "L":
                    ((current.x - distance)..<current.x).reversed().forEach {
                        block(Point(x: $0, y: current.y))
                    }
                    current.x -= distance

                case "R":
                    ((current.x + 1)...(current.x + distance)).forEach {
                        block(Point(x: $0, y: current.y))
                    }
                    current.x += distance

                default:
                    fatalError()
                }
            }
            id += 1
        }
        return (cross, steps)
    }

    private struct Point: Hashable {
        var x: Int, y: Int
    }
}
