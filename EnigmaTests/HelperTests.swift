//
//  HelperTests.swift
//  Enigma
//
//  Created by Leonard Mehlig on 31/03/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

import XCTest
@testable import Enigma
class HelperTests: XCTestCase {
    
    //MARK: - Random String
    func testRandomStringLength() {
        for _ in 0..<10 {
            let length = Int(arc4random_uniform(10000))
            let ranStr = String.randomLetters(.Both, length: length)
            XCTAssert(ranStr.characters.count == length, "Random string  dosnt have length \(length). Instead String (\(ranStr)) is \(ranStr.characters.count) long")
        }
    }
    
    func testRandomUpperCaseString() {
        for _ in 0..<10 {
            let ranStr = String.randomLetters(.Upper, length: 500)
            XCTAssert(ranStr == ranStr.uppercaseString, "Not every character in the string is uppercase: \(ranStr)")
        }
    }
    
    func testRandomLowerCaseString() {
        for _ in 0..<10 {
            let ranStr = String.randomLetters(.Lower, length: 500)
            XCTAssert(ranStr == ranStr.lowercaseString, "Not every character in the string is lowercase: \(ranStr)")
        }
    }
    
    func testRandomString() {
        let upperRange = ("A".unicodeScalars.first!.value..."Z".unicodeScalars.first!.value)
        let lowerRange = ("a".unicodeScalars.first!.value..."z".unicodeScalars.first!.value)
        for _ in 0..<10 {
            let ranStr = String.randomLetters(.Both, length: 500)
            for scalar in ranStr.unicodeScalars {
                XCTAssert(upperRange ~= scalar.value || lowerRange ~= scalar.value, "No letter characters containt in string: \(ranStr)")
            }
        }
    }
}
