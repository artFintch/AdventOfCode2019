//
//  main.swift
//  Sandbox
//
//  Created by Vyacheslav Khorkov on 01.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import Frog

// TODO: Need refuck that shit

let lines = Frog("input.txt").readLines().map {
    $0.components(separatedBy: ",").compactMap(Int.init)
}

func getDigits(num: Int) -> [Int] {
    guard num != 0 else {
        return [0]
    }
    var digits: [Int] = []
    var num = num
    while num > 0 {
        let lastDigit = num % 10
        num /= 10
        digits.append(lastDigit)
    }
    return digits
}

//var inp = 1
func runProgram(_ nums: [Int], _ a: Int, inp: [Int], _index: Int = 0) -> ([Int], Int, Int, Bool) {
    var inp_i = 0
    var nums = nums
    var inp = inp
//    nums[1] = a
    var index = _index
    while index < nums.count {
        var digits = getDigits(num: nums[index])

        if digits.isEmpty {
            fatalError()
            //return (nums, inp[inp_i], index, false)
        }

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
                nums[nums[index + 1]] = inp[inp_i]
            } else {
                nums[index + 1] = inp[inp_i]
            }
            if inp_i == 0 { inp_i += 1 }
            index += 2
        case 4:
            // out
            let arg1 = mode0 == 0 ? nums[nums[index + 1]] : nums[index + 1]
            inp[inp_i] = arg1
            index += 2
            print(arg1)
            if arg1 == 139629729 {
                print("")
            }
            return (nums, inp[inp_i], index, false)

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
            index += 1
            return (nums, inp[inp_i], index, true)
        default:
            fatalError()
        }
    }

    return (nums, -1, index, false)
}

//runProgram(lines[0], -1, inp: [0, 9])
//fatalError()

var firstRun = true
var nnums: [[Int]] = Array(repeating: lines[0], count: 5)
var indices: [Int] = Array(repeating: 0, count: 5)
func run(_ nums: [Int], amp: [Int], inp: Int = 0) -> (Int, Bool) {
    var inp = inp
    var finish = false
    for (i, a) in amp.enumerated() {
        var f = false
        let inp_a = firstRun ? [a, inp] : [inp, inp]
        (nnums[i], inp, indices[i], f) = runProgram(nnums[i], -1, inp: inp_a, _index: indices[i])
        if f {
            finish = f
        }
    }
    firstRun = false
    return (inp, finish)
}

var i = 0
//while true {
//    var f = false
//    (i, f) = run(lines[0], amp: [9,7,8,5,6], inp: i)
//    print("***", i)
//    if f {
//        break
//    }
//}
//fatalError()
//print(run(lines[0], amp: [4,3,2,1,0]))


// 0,1,2,3,4
var answers: [Int: [Int]] = [:]
for i1 in 5...9 {
    for i2 in 5...9 {
        for i3 in 5...9 {
            for i4 in 5...9 {
                for i5 in 5...9 {
                    i = 0
                    firstRun = true
                    nnums = Array(repeating: lines[0], count: 5)
                    indices = Array(repeating: 0, count: 5)
                    var set: Set<Int> = []
                    set.insert(i1)
                    set.insert(i2)
                    set.insert(i3)
                    set.insert(i4)
                    set.insert(i5)
                    guard set.count == 5 else { continue }
                    print([i1, i2, i3, i4, i5])

                    while true {
                        var f = false
                        (i, f) = run(lines[0], amp: [i1, i2, i3, i4, i5], inp: i)
                        print("***", i)
                        if f {
                            break
                        }
                    }
                    answers[i] = [i1, i2, i3, i4, i5]
                }
            }
        }
    }
}
//print(answers.count)
let m = answers.max(by: { $0.key < $1.key })
print(m)



//// silver
//var answer = -1
//input = 1
//for line in lines {
//    answer = runProgram(line, 1)
//    if answer != 0 { break }
//}
//assert(answer == 12440243)
//
//// gold
//answer = -1
//input = 5
//for line in lines {
//    answer = runProgram(line, 1)
//    if answer != 0 { break }
//}
//assert(answer == 15486302)
