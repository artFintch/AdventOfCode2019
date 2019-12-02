//
//  main.swift
//  Sandbox
//
//  Created by Vyacheslav Khorkov on 01.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import Frog

let frog = Frog("input.txt")
var numbers = frog
    .readLine()!
    .components(separatedBy: ",")
    .compactMap(Int.init)

func tryInput(_ numbers: [Int], _ a: Int, _ b: Int) -> Int {
    var numbers = numbers
    numbers[1] = a
    numbers[2] = b
    for start in stride(from: 0, to: numbers.count, by: 4) {
        if numbers[start] == 99 { break }
        let op: (Int, Int) -> Int = (numbers[start] == 1) ? (+) : (*)
        let (arg0, arg1) = (numbers[start + 1], numbers[start + 2])
        let output = numbers[start + 3]
        numbers[output] = op(numbers[arg0], numbers[arg1])
    }
    return numbers[0]
}

print(tryInput(numbers, 12, 2))
for a in 0..<100 {
    for b in 0..<100 {
        if tryInput(numbers, a, b) == 19690720 {
            print(a * 100 + b)
            break
        }
    }
}
