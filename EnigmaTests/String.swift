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
        case Upper, Lower, Both
        var isLower: Bool { return self == .Lower || self == .Both }
        var isUpper: Bool { return self == .Upper || self == .Both }
    }
    public static func randomLetters(`case`: Case = .Both, length: Int = 100) -> String {
        let t: [UInt32] = (0..<length).map { _ in
            let i = arc4random_uniform(`case` == .Both ? 52 : 26) + 65
            //let i = UInt32(`case` == .Both ? 52 : 26) + 65 - 1
            if i <= 90 && `case`.isUpper { return i }
            else if `case`.isLower { return `case` == .Both ? i + 6 : i + 32 }
            fatalError("")
        }
        return String(String.UnicodeScalarView(t.map { UnicodeScalar($0) }))
    }
}