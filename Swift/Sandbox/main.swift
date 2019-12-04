//
//  main.swift
//  Sandbox
//
//  Created by Vyacheslav Khorkov on 01.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import Frog

func isValidPass(_ pass: Int, uniqueCount: (Int) -> Bool) -> Bool {
    let string = String(pass)
    guard String(string.sorted()) == string else { return false }

    let counts: [Character: Int] = string.reduce(into: [:]) {
        $0[$1, default: 0] += 1
    }
    return counts.values.contains(where: uniqueCount)
}

let range = 197487..<673251
let silver = range.reduce(0) { $0 + (isValidPass($1, uniqueCount: { $0 > 1 }) ? 1 : 0) }
assert(silver == 1640)
let gold = range.reduce(0) { $0 + (isValidPass($1, uniqueCount: { $0 == 2 }) ? 1 : 0) }
assert(gold == 1126)
