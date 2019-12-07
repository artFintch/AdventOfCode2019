//
//  main.swift
//  Sandbox
//
//  Created by Vyacheslav Khorkov on 01.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import Frog

let lines = Frog("input.txt").readLines()

//var points: [String: String] = [:]
var points2: [String: Set<String>] = [:]
for line in lines {
    let labels = line.components(separatedBy: ")")
//    points[labels[1]] = labels[0]

    if labels[0] != "YOU" {
        points2[labels[1], default: []].insert(labels[0])
    }
    if labels[1] != "YOU" {
        points2[labels[0], default: []].insert(labels[1])
    }
}

//var count = 0
//for point in points {
//    var current: String? = point.key
//    while current != nil && points[current!] != nil {
//        count += 1
//        current = points[current!]
//    }
//}
//print(count)

var count = 0
var used: Set<String> = points2["YOU"]!
var queue: [String] = Array(points2["YOU"]!)
var path: [String: Int] = [:]
for p in queue {
    path[p] = 0
}
finish: while !queue.isEmpty {
    let first = queue.removeFirst()
    for p in points2[first]! {
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
print(path["SAN"]! - 1)

