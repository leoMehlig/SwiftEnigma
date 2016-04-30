//
//  Encryptable.swift
//  Enigma
//
//  Created by Leonard Mehlig on 25/03/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

public protocol Encryptable {
    static func encrypt(enigma enigma: EnigmaType) -> (Self -> Self)
    static func encrypt(dirComp: DirectedComponent) -> (Self -> Self)
    static func encryptComponent(direction direction: Direction) -> ComponentType -> (Self -> Self)
}

//MARK: - Default implementations

extension Encryptable {
    public static func encrypt(enigma enigma: EnigmaType) -> (Self -> Self) {
        return enigma.generateComponents().reduce(id, combine: { Self.encrypt($1) >>> $0})
    }
    
    public static func encryptComponent(direction direction: Direction) -> ComponentType -> (Self -> Self) {
        return { component in
            return Self.encrypt(component.encrypt(direction: direction))
        }
    }
}

extension Encryptable {
    public func encrypt(enigma enigma: EnigmaType) -> Self {
        return Self.encrypt(enigma: enigma)(self)
    }
    
    public func encrypt(component component: ComponentType, direction: Direction) -> Self {
        return Self.encryptComponent(direction: direction)(component)(self)
    }
}

//MARK: - Implementations

extension String: Encryptable {
    public static func encrypt(dirComp: DirectedComponent) -> (String -> String) {
        return { string in
            let scalars = string.unicodeScalars.map({ UnicodeScalar(dirComp(Int($0.value))) })
            return String(UnicodeScalarView(scalars))
        }
    }
    
    public func encrypt(enigma enigma: EnigmaType) -> String {
        return String(self.characters.encrypt(enigma: enigma).encrypted)
    }
}

extension Character: Encryptable {
    public static func encrypt(dirComp: DirectedComponent) -> (Character -> Character) {
        return { char in
            let scalar = dirComp(Int(char.unicodeScalar.value))
            return Character(UnicodeScalar(scalar))
        }
    }
}

extension Int: Encryptable {
    public static func encrypt(dirComp: DirectedComponent) -> (Int -> Int) {
        return dirComp
    }
}