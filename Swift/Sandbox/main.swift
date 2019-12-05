//
//  main.swift
//  Sandbox
//
//  Created by Vyacheslav Khorkov on 01.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import Frog

let lines = Frog("input.txt").readLines().map {
    $0.components(separatedBy: ",").compactMap(Int.init)
}

func getDigits(num: Int) -> [Int] {
    var digits: [Int] = []
    var num = num
    while num > 0 {
        let lastDigit = num % 10
        num /= 10
        digits.append(lastDigit)
    }
    return digits
}

var input = 1
func runProgram(_ nums: [Int], _ a: Int) -> Int {
    var nums = nums
//    nums[1] = a
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

// silver
var answer = -1
input = 1
for line in lines {
    answer = runProgram(line, 1)
    if answer != 0 { break }
}
assert(answer == 12440243)

// gold
answer = -1
input = 5
for line in lines {
    answer = runProgram(line, 1)
    if answer != 0 { break }
}
assert(answer == 15486302)
