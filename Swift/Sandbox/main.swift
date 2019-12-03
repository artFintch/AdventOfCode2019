//
//  main.swift
//  Sandbox
//
//  Created by Vyacheslav Khorkov on 01.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import Frog

let frog = Frog("input.txt")
let lines = frog.readLines().map {
    $0.components(separatedBy: ",")
}

struct Point: Hashable {
    var x: Int, y: Int
}

var id = 0
var cross: Set<Point> = []
var points: [Set<Point>] = [[], []]
var steps: [[Point: Int]] = [[:], [:]]
for line in lines {
    var stepsCount = 0
    let anotherId = Swift.abs(id - 1)
    var current = Point(x: 0, y: 0)
    for step in line {
        let direction = step.first!
        let distance = Int(step.dropFirst())!
        switch direction {
        case "U":
            ((current.y + 1)...(current.y + distance)).forEach {
                stepsCount += 1
                let point = Point(x: current.x, y: $0)
                points[id].insert(point)
                steps[id][point] = stepsCount
                if points[anotherId].contains(point) {
                    cross.insert(point)
                }
            }
            current.y += distance

        case "D":
            ((current.y - distance)..<current.y).reversed().forEach {
                stepsCount += 1
                let point = Point(x: current.x, y: $0)
                points[id].insert(point)
                steps[id][point] = stepsCount
                if points[anotherId].contains(point) {
                    cross.insert(point)
                }
            }
            current.y -= distance

        case "L":
            ((current.x - distance)..<current.x).reversed().forEach {
                stepsCount += 1
                let point = Point(x: $0, y: current.y)
                points[id].insert(point)
                steps[id][point] = stepsCount
                if points[anotherId].contains(point) {
                    cross.insert(point)
                }
            }
            current.x -= distance

        case "R":
            ((current.x + 1)...(current.x + distance)).forEach {
                stepsCount += 1
                let point = Point(x: $0, y: current.y)
                points[id].insert(point)
                steps[id][point] = stepsCount
                if points[anotherId].contains(point) {
                    cross.insert(point)
                }
            }
            current.x += distance

        default:
            fatalError()
        }
    }
    id += 1
}

let min = cross.map { Swift.abs($0.x) + Swift.abs($0.y) }.min()!
print(min)

let min2 = cross.map {
    return steps[0][$0]! + steps[1][$0]!
}.min()!
print(min2)
