//
//  main.swift
//  Sandbox
//
//  Created by Vyacheslav Khorkov on 01.12.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import Frog

struct Vector { var x, y, z: Int }
func readInput(from path: String) -> [Vector] {
    return Frog(path).readLines().map {
        let coordinates = $0.components(separatedBy: ["<", "=", ",", " ", ">"])
            .compactMap(Int.init)
        return Vector(x: coordinates[0], y: coordinates[1], z: coordinates[2])
    }
}

struct Moon { var position: Vector; var velocity: Vector }
func makeStep(_ moons: [Moon]) -> [Moon] {
    var moons = moons
    for i in moons.indices {
        for j in moons.indices where i != j {
            if moons[i].position.x > moons[j].position.x {
                moons[i].velocity.x -= 1
            } else if moons[i].position.x < moons[j].position.x {
                moons[i].velocity.x += 1
            }

            if moons[i].position.y > moons[j].position.y {
                moons[i].velocity.y -= 1
            } else if moons[i].position.y < moons[j].position.y {
                moons[i].velocity.y += 1
            }

            if moons[i].position.z > moons[j].position.z {
                moons[i].velocity.z -= 1
            } else if moons[i].position.z < moons[j].position.z {
                moons[i].velocity.z += 1
            }
        }
    }
//    moons.forEach { print($0) }

    for i in moons.indices {
        moons[i].position.x += moons[i].velocity.x
        moons[i].position.y += moons[i].velocity.y
        moons[i].position.z += moons[i].velocity.z
    }

    return moons
}

let input = readInput(from: "input.txt")
let origin = input.map { Moon(position: $0, velocity: Vector(x: 0, y: 0, z: 0)) }
var moons = origin
//var steps = 1000
//while steps > 0 {
//    moons = makeStep(moons)
//    steps -= 1
//}
//
//let energy = moons.reduce(0) {
//    let pot = Swift.abs($1.position.x) + Swift.abs($1.position.y) + Swift.abs($1.position.z)
//    let kin = Swift.abs($1.velocity.x) + Swift.abs($1.velocity.y) + Swift.abs($1.velocity.z)
//    return $0 + pot * kin
//}
//print(energy)

//var steps = 0
//while true {
//    moons = makeStep(moons)
//    steps += 1
//
//    if moons.allSatisfy({ $0.velocity.x == 0 && $0.velocity.y == 0 && $0.velocity.z == 0 }) {
//        var same = true
//        for i in moons.indices{
//            if moons[i].position.x != origin[i].position.x ||
//                moons[i].position.y != origin[i].position.y ||
//                moons[i].position.z != origin[i].position.z {
//                same = false
//                break
//            }
//        }
//        if same {
//            print(steps)
//            moons.forEach { print($0) }
//            break
//        }
//    }
//    if steps % 1000 == 0 {
//        print(steps)
//    }
//}

var steps = 0
while true {
    moons = makeStep(moons)
    steps += 1

    if moons.allSatisfy({ $0.velocity.x == 0 }) {
        var same = true
        for i in moons.indices{
            if moons[i].position.x != origin[i].position.x {
                same = false
                break
            }
        }
        if same {
            print(steps)
            moons.forEach { print($0) }
            break
        }
    }
}

// x 113028
// y 167624
// z 231614

func gcd(_ a: Int, _ b: Int) -> Int {
    if b == 0 { return a }
    else { return gcd(b, a % b) }
}
func lcm(_ a: Int, _ b: Int) -> Int {
    return a / gcd(a, b) * b
}

print(lcm(lcm(113028, 167624), 231614))
