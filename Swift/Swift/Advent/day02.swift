//
//  day02.swift
//  Tests
//
//  Created by v.khorkov on 02.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import AdventCode
import Frog

struct Day02: Solution {

    func readInput(from path: String) -> [Int] {
        return Frog(path)
            .readLine()!
            .components(separatedBy: ",")
            .compactMap(Int.init)
    }

    func silver(_ input: [Int]) -> Int {
        return runProgram(input, 12, 2)
    }

    func gold(_ input: [Int]) -> Int {
        for a in 0..<100 {
            for b in 0..<100 {
                if runProgram(input, a, b) == 19690720 {
                    return a * 100 + b
                }
            }
        }
        fatalError("Probably need to increase top boundaries.")
    }

    private func runProgram(_ nums: [Int], _ a: Int, _ b: Int) -> Int {
        var nums = nums
        (nums[1], nums[2]) = (a, b)
        for start in stride(from: 0, to: nums.count, by: 4) {
            if nums[start] == 99 { break }
            let op: (Int, Int) -> Int = (nums[start] == 1) ? (+) : (*)
            let (arg0, arg1) = (nums[start + 1], nums[start + 2])
            let output = nums[start + 3]
            nums[output] = op(nums[arg0], nums[arg1])
        }
        return nums[0]
    }
}
