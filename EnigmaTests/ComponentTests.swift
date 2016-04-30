//
//  ComponentTests.swift
//  Enigma
//
//  Created by Leonard Mehlig on 31/03/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

import XCTest
@testable import Enigma
class ComponentTests: XCTestCase {

    func testComponent(comp: ComponentType) {
        let testString = String.randomLetters()
        let inEncrypted = testString.encrypt(component: comp, direction: .In)
        let outEncrypted = inEncrypted.encrypt(component: comp, direction: .Out)
        XCTAssertEqual(testString, outEncrypted, "String isnt the same after in out encryption!")
    }
    
    func testSameComp() {
        testComponent(SameComponent())
    }
    
    
    func testSuccessComp() {
        let test: Int -> () = { success in
            self.testComponent(SuccessComponent(success: success))
        }
        for _ in 0..<10 {
            test(Int(arc4random_uniform(100)))
        }
    }
    
    func testAnyCompLazyness() {
        let comp = AnyComponent(
            in: { Int(arc4random_uniform(UInt32($0))) },
            out: { _ in  0; fatalError() })
        "abc".encrypt(component: comp, direction: .In)
    }

}
