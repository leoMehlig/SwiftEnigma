//
//  Character.swift
//  Enigma
//
//  Created by Leonard Mehlig on 02/04/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

extension Character {
    public var unicodeScalar: UnicodeScalar {
        return String(self).unicodeScalars.first!
    }
    
    
}