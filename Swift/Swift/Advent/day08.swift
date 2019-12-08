//
//  day08.swift
//  Tests
//
//  Created by Vyacheslav Khorkov on 08.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import AdventCode
import Frog

struct Day08: Solution {

    func readInput(from path: String) -> [Int] {
        return Frog(path)
            .readLine()!
            .compactMap(String.init)
            .compactMap(Int.init)
    }

    func silver(_ nums: [Int]) -> Int {
        let (rows, columns) = (25, 6)
        let layerSize = columns * rows
        let layers = nums.count / layerSize

        let range: (Int) -> Range<Int> = { ($0 * layerSize)..<(($0 + 1) * layerSize) }
        let countZeros: (Int, Int) -> Int = { $0 + ($1 == 0 ? 1 : 0) }
        let minLayer = (0..<layers).min { layer0, layer1 in
            let lhs = nums[range(layer0)].reduce(0, countZeros)
            let rhs = nums[range(layer1)].reduce(0, countZeros)
            return lhs < rhs
        }

        let minRange = range(minLayer!)
        let countOnes: (Int, Int) -> Int = { $0 + ($1 == 1 ? 1 : 0) }
        let ones = nums[minRange].reduce(0, countOnes)
        let countTwos: (Int, Int) -> Int = { $0 + ($1 == 2 ? 1 : 0) }
        let twos = nums[minRange].reduce(0, countTwos)

        return ones * twos
    }

    func gold(_ nums: [Int]) -> String {
        let (rows, columns) = (25, 6)
        let map = buildMap(nums, rows: rows, columns: columns)
        let layers = nums.count / (columns * rows)
        var image: [[Int]] = Array(repeating: Array(repeating: 0, count: rows), count: columns)
        for column in 0..<columns {
            for row in 0..<rows {
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

        let correctImage = [
            [1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0],
            [1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0],
            [1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0],
            [1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0],
            [1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0],
            [1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 0]
        ]
        if correctImage != image {
            fatalError()
        }

         //for row in image {
         //   print(row)
         //}

        // Can't take answer automatically:
        return "EBZUR"
    }

    private func buildMap(_ nums: [Int], rows: Int, columns: Int) -> [[[Int]]] {
        var current = 0
        let layerSize = columns * rows
        let layers = nums.count / layerSize
        let column = Array(repeating: -1, count: rows)
        let layer = Array(repeating: column, count: columns)
        var map = Array(repeating: layer, count: layers)
        for layer in 0..<layers {
            for column in 0..<columns {
                for row in 0..<rows {
                    map[layer][column][row] = nums[current]
                    current += 1
                }
            }
        }
        return map
    }
}
