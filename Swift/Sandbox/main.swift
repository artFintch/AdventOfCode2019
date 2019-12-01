//
//  main.swift
//  Sandbox
//
//  Created by Vyacheslav Khorkov on 01.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import Frog

let frog = Frog("input.txt")
let numbers = frog.readLines().compactMap(Int.init)
let sum = numbers.reduce(0) {
    var n = $1
    var s = 0
    while (n / 3 - 2) > 0 {
        n = n / 3 - 2
        s += n
    }
    return $0 + s
}
print(sum)
