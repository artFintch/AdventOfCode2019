//
//  main.swift
//  Sandbox
//
//  Created by Vyacheslav Khorkov on 01.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import Frog

let input = Frog("input.txt").readLine()!
    .map(String.init)
    .compactMap(Int.init)

//var cache: [String: [Int]] = [:]
func getMult(row: Int, column: Int) -> Int {
    let width = 4 * (row + 1)
    let index = (column + 1) % width
    let localIndex = index / (row + 1)
    return [0, 1, 0, -1][localIndex]


//    let k = "\(column),\(row)"
//    let a = column/((row+1)*4)+2
//    if cache[k] != nil {
//        return cache[k]![column + 1]
//    }
//
//    let base = [0, 1, 0, -1]
//    var new: [Int] = []
//    for index in base {
//        for _ in 0..<(row+1) {
//            new.append(index)
//        }
//    }

//    [0, 0, 1, 1, 0, 0, -1, -1]
//    return base[(((column + row) % base.count) + 1) % base.count]


//    var new2: [Int] = []
//    for _ in 0...a {
//        new2.append(contentsOf: new)
//    }
//    cache[k] = new2
//    return new2[column + 1]
}

print(getMult(row: 0, column: 0) == 1)
print(getMult(row: 0, column: 1) == 0)
print(getMult(row: 0, column: 2) == -1)
print(getMult(row: 0, column: 3) == 0)
print(getMult(row: 0, column: 4) == 1)

print(getMult(row: 1, column: 5) == -1)
print(getMult(row: 1, column: 1) == 1)
print(getMult(row: 6, column: 5) == 0)


var ar: [[Int]] = Array(repeating: [], count: input.count)
func runPhase(input: [Int]) -> [Int] {
    var output: [Int] = []
    for row in input.indices {
//        var line = ""
        var sum = 0
        for column in input.indices {
            sum += input[column] * getMult(row: row, column: column)
//            print(column, a)
//            line += String("\(input[column])*\(getMult(row: row, column: column)) ")
        }
//        print(Double(row)/Double(input.count))
        let a = abs(sum % 10)
        output.append(a)
        ar[row].append(sum)
    }
    return output
}

func printNums(_ nums: [Int], _ nums2: [Int]) {
    print(nums.map(String.init).joined(), nums2.map(String.init).joined())
}

//print(5978017%650)
//617
var nums = input
//let offset = Int(nums[0..<7].map(String.init).joined())

//var nums2 = input + input
//printNums(nums, nums2)
var phase = 0
while phase < 100 {
    phase += 1
    nums = runPhase(input: nums)
//    nums2 = runPhase(input: nums2)
//    printNums(nums, [])
//    print("phase:", phase)
}
//print(nums[617..<625].map(String.init).joined())

for (i, aa) in ar.enumerated() {
    print(i, aa)
}

//var nums: [Int] = []
//for _ in 0..<1_000 {
//    nums.append(contentsOf: input)
//}

//var phase = 0
//while phase < 100 {
//    phase += 1
//    nums = runPhase(input: nums)
//    print("phase:", phase)
//}
//print(nums[0..<8].map(String.init).joined())


// 27, 17, 15, 33, 17
// 20, 10, 8, 28, 14
// 16, 10, 8, 20, 6
// 10, 4, 8, 12, 6
// 4, 4, 4, 4, 4
