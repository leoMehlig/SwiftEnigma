//
//  String.swift
//  Enigma
//
//  Created by Leonard Mehlig on 31/03/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

import Foundation
extension String {
    public enum Case {
        case upper, lower, both
        var isLower: Bool { return self == .lower || self == .both }
        var isUpper: Bool { return self == .upper || self == .both }
    }
    public static func randomLetters(_ case: Case = .both, length: Int = 100) -> String {
        let t: [UInt32] = (0..<length).map { _ in
            let i = arc4random_uniform(`case` == .both ? 52 : 26) + 65
            //let i = UInt32(`case` == .Both ? 52 : 26) + 65 - 1
            if i <= 90 && `case`.isUpper { return i }
            else if `case`.isLower { return `case` == .both ? i + 6 : i + 32 }
            fatalError("")
        }
        var scalarView = UnicodeScalarView()
        scalarView.append(contentsOf: t.flatMap { UnicodeScalar($0) })
        return String(scalarView)
    }
}
