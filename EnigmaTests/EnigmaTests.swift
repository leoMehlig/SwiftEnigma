//
//  EnigmaTests.swift
//  EnigmaTests
//
//  Created by Leonard Mehlig on 25/03/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

import XCTest
@testable import Enigma

class EnigmaTests: XCTestCase {
    func testEnigma() {
        let comp = MapComponent(map: [1:2, 2:3, 3:4, 4:1])
        let ref = MapComponent(map: [1:2, 2:1, 3:4, 4:3])
        let enigma = Enigma(components: [comp, comp, comp], reflect: ref)
        
        for i in 1...4 {
            let encrypted = i.encrypt(with: enigma)
            XCTAssertEqual(i, encrypted.encrypt(with: enigma), "Decrypted value is not the same as original")
        }
        
    }
    
    func testFullEnigma() {
        let plugboard = MapComponent(pairs: [
            ("a", "q"),
            ("b", "e"),
            ("c", "n"),
            ("d", "p"),
            ("f", "r"),
            ("g", "i"),
            ("h", "u"),
            ("j", "t"),
            ("k", "m"),
            ("l", "w"),
            ("o", "s"),
            ("v", "x"),
            ("y", "z"),
            ])
        let rotor1 = StandardRotor.i.component()
        let rotor2 = StandardRotor.ii.component()
        let rotor3 = StandardRotor.iii.component()
        let reflector = StandardReflector.b.component
        
        let string = "hellowwdc"
        let enigma = Enigma(components: [plugboard, rotor1, rotor2, rotor3], reflect: reflector)
        let encrypted = string.encrypt(with: enigma)
        XCTAssertEqual(string, encrypted.encrypt(with: enigma), "Decrypted value is not the same as original")

    }
    
    func testRotorEnigma() {
        let rotor1 = RotorComponent(connections: [
            "a" : "d",
            "b" : "c",
            "c" : "b",
            "d" : "a"], offset: "b", turnover: "c")
        
        let rotor2 = RotorComponent(connections: [
            "c" : "d",
            "b" : "a",
            "d" : "b",
            "a" : "c"], offset: "d", turnover: "a")
        let ref = MapComponent(pairs: [("a", "b"), ("d", "c")])
        let enigma = Enigma(components: [rotor1, rotor2], reflect: ref)
        let string = "abcd"
        let encrypted = string.encrypt(with: enigma)

        XCTAssertEqual(string, encrypted.encrypt(with: enigma), "Decrypted value is not the same as original")

    }
    
    func testEnigmaPerformance() {
        let string = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA".lowercased()
        let expected = "FTZMGISXIPJWGDNJJCOQTYRIGDMXFIESRWZ".lowercased()
        measure {
            let rotors: [ComponentType] = [StandardRotor.i.component(), StandardRotor.ii.component(), StandardRotor.iii.component()]
            let ref = StandardReflector.b.component
            let enigma = Enigma(components: rotors, reflect: ref)
            XCTAssert(string.encrypt(with: enigma) == expected, "Wrong encryption")
        }
    }
    
    func testSecodeRotorExtraTurn() {
        let rotors: [ComponentType] = [StandardRotor.i.component().step(by: 15, atPosition: 0).0, StandardRotor.ii.component().step(by: 3, atPosition: 1).0, StandardRotor.iii.component()]
        let ref = StandardReflector.b.component
        let enigma = Enigma(components: rotors, reflect: ref)
        let string = "aaaa"
        let expected = "dzgo"
        XCTAssertEqual(expected, string.encrypt(with: enigma), "Wrong encryption")
    }
}
