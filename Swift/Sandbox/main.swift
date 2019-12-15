//
//  main.swift
//  Sandbox
//
//  Created by Vyacheslav Khorkov on 01.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import Frog

struct E: Equatable {
    let name: String
    let count: Int
}
struct R {
    let from: E
    let to: E
}

func readInput(from path: String) -> [String: [R]] {
    var table: [String: [R]] = [:]
    Frog(path).readLines().forEach {
        let sides: [String] = $0.components(separatedBy: " => ")
        let leftSide: [E] = sides[0].components(separatedBy: ", ").map { (part: String) in
            let parts = part.components(separatedBy: " ")
            return E(name: parts[1], count: Int(parts[0])!)
        }
        let rightParts = sides[1].components(separatedBy: " ")
        let rightSide = E(name: rightParts[1], count: Int(rightParts[0])!)
        table[rightSide.name] = leftSide.map {
            R(from: rightSide, to: $0)
        }
    }
    return table
}

func tryReact(element: E, table: [String: [R]]) -> [E] {
//    if element.name == "ORE" { return [] }
    if element.count < 0 { return [element] }
    let reactions = table[element.name, default: []]
    let a = element.count / reactions[0].from.count
    let b = (element.count % reactions[0].from.count == 0) ? a : a + 1
    var newElements: [E] = reactions.compactMap {
        if $0.to.name == "ORE" { return nil }
//        print(element, $0.from, $0.to)
//        print($0.from.name, "\(element.count) (\(b * $0.from.count))", " / ", $0.from.count, " * ", $0.to.count, " = ", b * $0.to.count, $0.to.name)
//        print("")
        return E(name: $0.to.name, count: b * $0.to.count)
    }
    if !newElements.isEmpty, element.count != b * reactions[0].from.count {
        newElements.append(E(name: element.name, count: element.count - b * reactions[0].from.count))
    }
    return newElements
}

func calcORE(elements: [String: E], table: [String: [R]]) -> Int {
    return elements.values.reduce(0) {
        if $1.count < 0 { return $0 }
        let r = table[$1.name]![0]
        let a = $1.count / r.from.count
        let b = ($1.count % r.from.count == 0) ? a : a + 1
        return $0 + b * r.to.count
    }
}

//    9 ORE => 2 A
//    8 ORE => 3 B
//    7 ORE => 5 C
//    3 A, 4 B => 1 AB
//    5 B, 7 C => 1 BC
//    4 C, 1 A => 1 CA
//    2 AB, 3 BC, 4 CA => 1 FUEL
let table = readInput(from: "input.txt")

func printElements(_ elements: [E]) {
    var output: [String] = []
    for element in elements.sorted(by: { $0.name < $1.name }) {
        output.append(String("\(element.count) \(element.name)"))
    }
    print(output.joined(separator: " + "))
}

func calculateOREforFUEL(fuel: Int) -> Int {
    var react = false
    var elements: [String: E] = ["FUEL": E(name: "FUEL", count: fuel)]
    repeat {
        react = false
        for (key, element) in elements {
            let new = tryReact(element: element, table: table)
            if new.isEmpty || new == [element] { continue }

//            printElements(new)
            elements.removeValue(forKey: key)
            for newElement in new {
                elements[newElement.name] = E(
                    name: newElement.name,
                    count: (elements[newElement.name]?.count ?? 0) + newElement.count
                )
            }
//            printElements(Array(elements.values))
//            print("")
            react = true
            break
        }
    } while react

    return calcORE(elements: elements, table: table)
}

print("*", calculateOREforFUEL(fuel: 1))

let ore = 1_000_000_000_000
var low = 1
var up = 999_999_999_999
while low < up {
    let middle = low + (up - low) / 2
    let result = calculateOREforFUEL(fuel: middle)
    if result == ore {
        low = middle
        break
    } else if result < ore {
        low = middle + 1
    } else {
        up = middle - 1
    }
}

let maxFuel = [low, low + 1, low - 1].filter {
    calculateOREforFUEL(fuel: $0) < ore
}.max()!
print("**", maxFuel)
