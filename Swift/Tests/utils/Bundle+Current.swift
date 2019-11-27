//
//  Bundle+Current.swift
//  Tests
//
//  Created by v.khorkov on 27.11.2019.
//  Copyright © 2019 v.khorkov. All rights reserved.
//

import Foundation

private class Dummy {}

extension Bundle {
    static let current = Bundle(for: Dummy.self)
}
