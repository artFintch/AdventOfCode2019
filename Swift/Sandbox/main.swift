//
//  main.swift
//  Sandbox
//
//  Created by Vyacheslav Khorkov on 01.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import Frog

func readInput(from path: String) -> [[String]] {
    return Frog(path).readLines().map {
        $0.map(String.init)
    }
}

struct Point: Hashable { let x, y: Int }
func +(lhs: Point, rhs: Point) -> Point {
    return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

struct End: Hashable {
    let point: Point
    let isKey: Bool
    let keys: Set<String>
    let dist: Int
}

func dfs(begin: Point,
         map: [[String]],
         visited: Set<Point>,
         keys: Set<String>,
         path: inout [Point: Int],
         ends: inout [End]) {
    var visited = visited
    var keys = keys
    let traverse = [begin + Point(x: -1, y: 0),
                    begin + Point(x: 0, y: -1),
                    begin + Point(x: 1, y: 0),
                    begin + Point(x: 0, y: 1)]
    for next in traverse where !visited.contains(next) {
        visited.insert(next)
        let label = map[next.y][next.x]
        switch label {
        case "#":
            continue

        case ".":
            path[next] = path[begin]! + 1
            dfs(begin: next, map: map, visited: visited, keys: keys, path: &path, ends: &ends)

        default:
            path[next] = path[begin]! + 1
            if label == label.uppercased() {
                if !keys.contains(label.lowercased()) {
                    continue
                }
                ends.append(End(point: next, isKey: false, keys: keys, dist: path[next]!))
            } else {
                keys.insert(label)
                ends.append(End(point: next, isKey: true, keys: keys, dist: path[next]!))
            }
            dfs(begin: next, map: map, visited: visited, keys: keys, path: &path, ends: &ends)
        }
    }
}

var map = readInput(from: "input.txt")
let y = map.firstIndex(where: { $0.contains("@") })!
let x = map[y].firstIndex(where: { $0 == "@" })!
map[y][x] = "."
var begin = Point(x: x, y: y)

//var path: [Point: Int] = [begin: 0]
//var ends: [End] = []
//dfs(begin: begin, map: map, visited: [begin], keys: [], path: &path, ends: &ends)
//print(ends)
//
//var keys = ends[0].keys
//begin = ends[0].point
//ends.removeAll()
//map[begin.y][begin.x] = "."
//dfs(begin: begin, map: map, visited: [begin], keys: keys, path: &path, ends: &ends)
//print(ends)
//
//keys = ends[1].keys
//begin = ends[1].point
//ends.removeAll()
//map[begin.y][begin.x] = "."
//dfs(begin: begin, map: map, visited: [begin], keys: keys, path: &path, ends: &ends)
//map.forEach { print($0) }
//print(ends)

var count = 0
var hashed = 0
var hash: [Set<End>: Int] = [:]
func searchPaths(ends: [End], map: [[String]], min: Int) -> Int {
    count += 1
    let hashKey = Set(ends.filter({ $0.isKey }))
    if hash[hashKey] != nil {
        return hash[hashKey]!
    }
    hashed += 1
    var min = min
    for end in ends where end.isKey {
        if min <= end.dist {
            continue
        }
        var _ends: [End] = []
        var path: [Point: Int] = [end.point: 0]
        var map = map
        map[end.point.y][end.point.x] = "."
//        print(end.dist)
//        map.forEach { print($0.joined()) }
        dfs(begin: end.point, map: map, visited: [end.point], keys: end.keys, path: &path, ends: &_ends)
        if !_ends.contains(where: { $0.isKey }) {
            min = Swift.min(min, end.dist)
//            print("finish")
            continue
        }
        _ends = _ends.map {
            End(point: $0.point, isKey: $0.isKey, keys: $0.keys, dist: end.dist + $0.dist)
        }
        min = Swift.min(searchPaths(ends: _ends, map: map, min: min), min)
    }
    hash[hashKey] = min
    return min
}

print(searchPaths(ends: [End(point: begin, isKey: true, keys: [], dist: 0)], map: map, min: 99999))
print(hashed, count)
