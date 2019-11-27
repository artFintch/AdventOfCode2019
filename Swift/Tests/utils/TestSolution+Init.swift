//
//  TestSolution+Init.swift
//  Tests
//
//  Created by v.khorkov on 27.11.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import AdventCode

extension TestSolution {
    init(silverAnswer: Type.SilverOutput,
         goldAnswer: Type.GoldOutput) {
        let resource = String(describing: Type.self).lowercased()
        self.init(inputPath: Bundle.current.txtPath(forResource: resource)!,
                  silverAnswer: silverAnswer,
                  goldAnswer: goldAnswer)
    }
}
