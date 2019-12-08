//
//  main.swift
//  Sandbox
//
//  Created by Vyacheslav Khorkov on 01.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import Frog

let line = Frog("input.txt").readLine()!.compactMap {
    Int(String($0))
}

var current = 0
var columnSize = 6
var rowSize = 25
var layers = line.count/(columnSize*rowSize)
var map: [[[Int]]] = Array(repeating: Array(repeating: Array(repeating: -1, count: rowSize), count: columnSize), count: layers)

for layer in 0..<layers {
    for column in 0..<columnSize {
        for row in 0..<rowSize {
            map[layer][column][row] = line[current]
            current += 1
        }
    }
}

var counts: [Int] = []
for layer in 0..<layers {
    counts.append(
        map[layer].flatMap { $0 }.reduce(0) { $0 + (($1 == 0) ? 1 : 0) }
    )
}

var imin = -1
var min = 999999
for i in counts.indices {
    if counts[i] < min {
        min = counts[i]
        imin = i
    }
}

print(map[imin])
let a = map[imin].flatMap { $0 }.reduce(0) { $0 + (($1 == 1) ? 1 : 0) }
let b = map[imin].flatMap { $0 }.reduce(0) { $0 + (($1 == 2) ? 1 : 0) }
print(a * b)
// 1224

// gold

var image: [[Int]] = Array(repeating: Array(repeating: 0, count: rowSize), count: columnSize)
for column in 0..<columnSize {
    for row in 0..<rowSize {
        for layer in 0..<layers {
            if map[layer][column][row] == 0 {
                // black
                image[column][row] = map[layer][column][row]
                break
            } else if map[layer][column][row] == 1 {
                // white
                image[column][row] = map[layer][column][row]
                break
            } else {
                // transparent
                continue
            }
        }
    }
}

for row in image {
    print(row.map { $0 == 1 ? "#" : "." })
}
// EBZUR
