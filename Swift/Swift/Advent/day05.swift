//
//  day05.swift
//  Tests
//
//  Created by Vyacheslav Khorkov on 09.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import AdventCode
import Frog

struct Day05: Solution {

    func readInput(from path: String) -> [Int] {
        return Frog(path).readLine()!
            .components(separatedBy: ",")
            .compactMap(Int.init)
    }

    func silver(_ nums: [Int]) -> Int {
        return runProgram(nums, input: 1)
    }

    func gold(_ nums: [Int]) -> Int {
        return runProgram(nums, input: 5)
    }

    private func runProgram(_ nums: [Int], input: Int) -> Int {
        var input = input
        var nums = nums
        var index = 0
        while index < nums.count {
            var digits = getDigits(num: nums[index])

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
                let arg1 = mode0 == 0 ? nums[nums[index + 1]] : nums[index + 1]
                let arg2 = mode1 == 0 ? nums[nums[index + 2]] : nums[index + 2]
                nums[nums[index + 3]] = arg1 + arg2
                index += 4

            case 2:
                // *
                let arg1 = mode0 == 0 ? nums[nums[index + 1]] : nums[index + 1]
                let arg2 = mode1 == 0 ? nums[nums[index + 2]] : nums[index + 2]
                nums[nums[index + 3]] = arg1 * arg2
                index += 4

            case 3:
                // in
                if mode0 == 0 {
                    nums[nums[index + 1]] = input
                } else {
                    nums[index + 1] = input
                }
                index += 2

            case 4:
                // out
                let arg1 = mode0 == 0 ? nums[nums[index + 1]] : nums[index + 1]
                input = arg1
                index += 2

            case 5:
                // jump-if-true
                let arg1 = mode0 == 0 ? nums[nums[index + 1]] : nums[index + 1]
                let arg2 = mode1 == 0 ? nums[nums[index + 2]] : nums[index + 2]
                if arg1 != 0 {
                    index = arg2
                } else {
                    index += 3
                }

            case 6:
                // jump-if-false
                let arg1 = mode0 == 0 ? nums[nums[index + 1]] : nums[index + 1]
                let arg2 = mode1 == 0 ? nums[nums[index + 2]] : nums[index + 2]
                if arg1 == 0 {
                    index = arg2
                } else {
                    index += 3
                }

            case 7:
                // less
                let arg1 = mode0 == 0 ? nums[nums[index + 1]] : nums[index + 1]
                let arg2 = mode1 == 0 ? nums[nums[index + 2]] : nums[index + 2]
                if mode2 == 0 {
                    nums[nums[index + 3]] = arg1 < arg2 ? 1 : 0
                } else {
                    nums[index + 3] = arg1 < arg2 ? 1 : 0
                }
                index += 4

            case 8:
                // equals
                let arg1 = mode0 == 0 ? nums[nums[index + 1]] : nums[index + 1]
                let arg2 = mode1 == 0 ? nums[nums[index + 2]] : nums[index + 2]
                if mode2 == 0 {
                    nums[nums[index + 3]] = arg1 == arg2 ? 1 : 0
                } else {
                    nums[index + 3] = arg1 == arg2 ? 1 : 0
                }
                index += 4

            case 99:
                return input

            default:
                fatalError()
            }
        }

        return 0
    }

    private func getDigits(num: Int) -> [Int] {
        var digits: [Int] = []
        var num = num
        while num > 0 {
            let lastDigit = num % 10
            num /= 10
            digits.append(lastDigit)
        }
        return digits
    }
}
