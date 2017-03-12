//
//  SameCompTests.swift
//  Enigma
//
//  Created by Leonard Mehlig on 29/03/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

import XCTest
import Enigma

class SameCompTest: XCTestCase {
    let longString = String(String.UnicodeScalarView((0...750).flatMap(UnicodeScalar.init)))
    let randomStrings = [
        "walLhLXKSWkmfrUDdlJWwlAauyRqEllKMHgaSZAlnhBYSmJovWmHhVgDewgstvXvojahEpBlZApKTgqbwSOTguWAfdmSTWjnsMOl",
        "yRkgZtEHsTIiUgumxDXSxkfcCmuTtMNkXblQPdUgdgGkxUDuzHEPOEvIGOrJjdfLNSYCwaWQfYYdCKUBeUFUCIlOVPIgrwWaXuhN",
        "PnVHCIHCdyEpciySHcYEOKzrqipagINFENDiITgjwHDBBgwWgPCRjAkmPqEQSYsbhLoXKZKCzwYPHSVfEgAdkPlkCghZunzjJdMI"
    ]
    
    let comp = SameComponent()
    
    func testSameComponent() {
        let test: (Direction) -> () = { direction in
            XCTAssert(
                self.longString.encrypt(component: self.comp, direction: direction) == self.longString,
                "Long string is not the same after a one to one encryption using SameComponent!!! Direction: \(direction)")
            
            let unequalStrings = self.randomStrings.flatMap({ $0.encrypt(component: self.comp, direction: direction) == $0 ? nil : $0 })
            XCTAssert(
                unequalStrings.isEmpty,
                "The following strings where not the same after SmaeComp encryption: \(unequalStrings). Direction: \(direction)")
        }
        
        test(.in)
        test(.out)
    }
    
    func testOneWayEnigma() {
        let enigma = OneWayEnigma(components: [comp, comp, comp])
        XCTAssert(longString.encrypt(enigma: enigma) == longString, "Long string is not the same after a one to one encryption using three SameComponents in a Enigma!!!")
        
        let unequalStrings = randomStrings.flatMap({ $0.encrypt(enigma: enigma) == $0 ? nil : $0 })
        XCTAssert(unequalStrings.isEmpty, "The following strings where not the same after SameComp encryption: \(unequalStrings)")
    }
}
