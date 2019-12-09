//
//  day06.swift
//  Tests
//
//  Created by Vyacheslav Khorkov on 09.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import AdventCode
import Frog

struct Day06: Solution {

    func readInput(from path: String) -> [String] {
        return Frog(path).readLines()
    }

    func silver(_ lines: [String]) -> Int {
        var points: [String: String] = [:]
        for line in lines {
            let labels = line.components(separatedBy: ")")
            points[labels[1]] = labels[0]
        }

        var count = 0
        for point in points {
            var current: String? = point.key
            while current != nil && points[current!] != nil {
                count += 1
                current = points[current!]
            }
        }
        return count
    }

    func gold(_ lines: [String]) -> Int {
        var points: [String: Set<String>] = [:]
        for line in lines {
            let labels = line.components(separatedBy: ")")

            if labels[0] != "YOU" {
                points[labels[1], default: []].insert(labels[0])
            }
            if labels[1] != "YOU" {
                points[labels[0], default: []].insert(labels[1])
            }
        }

        var used: Set<String> = points["YOU"]!
        var queue: [String] = Array(points["YOU"]!)
        var path: [String: Int] = [:]
        for p in queue {
            path[p] = 0
        }
        finish: while !queue.isEmpty {
            let first = queue.removeFirst()
            for p in points[first]! {
                if !used.contains(p) {
                    queue.append(p)
                    path[p, default: 0] = (path[first] ?? 0) + 1
                }
                used.insert(p)
                if p == "SAN" {
                    break finish
                }
            }
        }
        return path["SAN"]! - 1
    }
}
