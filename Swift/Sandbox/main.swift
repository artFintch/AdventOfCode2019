//
//  main.swift
//  Sandbox
//
//  Created by Vyacheslav Khorkov on 01.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import Frog

struct Point: Equatable { let x, y: Int }
func ==(lhs: Point, rhs: Point) -> Bool { return lhs.x == rhs.x && lhs.y == rhs.y }

func input() -> [Point] {
    let lines = Frog("input.txt").readLines()
    var points: [Point] = []
    for y in lines.indices {
        for (x, character) in lines[y].enumerated() {
            guard character == "#" else { continue }
            points.append(Point(x: x, y: y))
        }
    }
    return points
}

func silver(points: [Point]) -> (Int, Int) {
    var counts: [Int] = []
    for source in points {
        var angels: Set<Double> = []
        for target in points where target != source {
            let angle = atan2(Double(target.x - source.x),
                              Double(target.y - source.y))
            angels.insert(angle)
        }
        counts.append(angels.count)
    }
    return counts.enumerated().max { $0.element < $1.element }!
}

func gold(points: [Point], station: Point) -> Int {
    var pointsMap: [Double: [Point]] = [:]
    for target in points where target != station {
        let angle = atan2(Double(target.x - station.x),
                          Double(target.y - station.y))
        pointsMap[angle, default: []].append(target)
    }

    func distance(_ lhs: Point, _ rhs: Point) -> Double {
        return sqrt(Double((rhs.x - lhs.x) * (rhs.x - lhs.x) + (rhs.y - lhs.y) * (rhs.y - lhs.y)))
    }
    for (key, _) in pointsMap {
        pointsMap[key]?.sort {
            distance($0, station) < distance($1, station)
        }
    }

    var count = 200
    while !pointsMap.isEmpty {
        for key in pointsMap.keys.sorted(by: >) {
            if !(pointsMap[key] ?? []).isEmpty {
                let removed = pointsMap[key]!.removeFirst()
                count -= 1
                if count == 0 {
                    return removed.x * 100 + removed.y
                }
            }
        }
    }
    return -1
}

let points = input()
let (maxPointIndex, count) = silver(points: points)
assert(count == 280)
assert(gold(points: points, station: points[maxPointIndex]) == 706)
