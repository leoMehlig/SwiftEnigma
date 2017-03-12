//
//  Encryptable.swift
//  Enigma
//
//  Created by Leonard Mehlig on 25/03/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

public protocol Encryptable {
    static func encrypt(enigma: EnigmaType) -> ((Self) -> Self)
    static func encrypt(_ dirComp: @escaping DirectedComponent) -> ((Self) -> Self)
    static func encryptComponent(direction: Direction) -> (ComponentType) -> ((Self) -> Self)
}

//MARK: - Default implementations

extension Encryptable {
    public static func encrypt(enigma: EnigmaType) -> ((Self) -> Self) {
        return enigma.generateComponents().reduce(id, { Self.encrypt($1) >>> $0})
    }
    
    public static func encryptComponent(direction: Direction) -> (ComponentType) -> ((Self) -> Self) {
        return { component in
            return Self.encrypt(component.encrypt(direction: direction))
        }
    }
}

extension Encryptable {
    public func encrypt(enigma: EnigmaType) -> Self {
        return Self.encrypt(enigma: enigma)(self)
    }
    
    public func encrypt(component: ComponentType, direction: Direction) -> Self {
        return Self.encryptComponent(direction: direction)(component)(self)
    }
}

//MARK: - Implementations

extension String: Encryptable {

    public static func encrypt(_ dirComp: @escaping DirectedComponent) -> ((String) -> String) {
        return { string in
            var scalarView = UnicodeScalarView()
            scalarView.append(contentsOf: string.unicodeScalars.flatMap({ UnicodeScalar(dirComp(Int($0.value))) }))
            return String(scalarView)
        }
    }
    
    public func encrypt(enigma: EnigmaType) -> String {
        return String(self.characters.encrypt(enigma: enigma).encrypted)
    }
}

extension Character: Encryptable {

    public static func encrypt(_ dirComp: @escaping DirectedComponent) -> ((Character) -> Character) {
        return { char in
            let scalar = dirComp(Int(char.unicodeScalar.value))
            return Character(UnicodeScalar(scalar)!)
        }
    }
}

extension Int: Encryptable {
    public static func encrypt(_ dirComp: @escaping DirectedComponent) -> ((Int) -> Int) {
        return dirComp
    }
}
