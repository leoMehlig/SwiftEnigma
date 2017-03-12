//
//  Encryptable.swift
//  Enigma
//
//  Created by Leonard Mehlig on 25/03/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

public protocol Encryptable {
    static func encrypt(with enigma: EnigmaType) -> ((Self) -> Self)
    static func encrypt(with component: @escaping DirectedComponent) -> ((Self) -> Self)
    static func encrypt(with direction: Direction) -> (ComponentType) -> ((Self) -> Self)
}

//MARK: - Default implementations

extension Encryptable {
    public static func encrypt(with enigma: EnigmaType) -> ((Self) -> Self) {
        return enigma.componentIterator.reduce(id, { Self.encrypt(with: $1) >>> $0})
    }
    
    public static func encrypt(with direction: Direction) -> (ComponentType) -> ((Self) -> Self) {
        return { component in
            return Self.encrypt(with: component.encrypt(with: direction))
        }
    }
}

extension Encryptable {
    public func encrypt(with enigma: EnigmaType) -> Self {
        return Self.encrypt(with: enigma)(self)
    }
    
    public func encrypt(component: ComponentType, direction: Direction) -> Self {
        return Self.encrypt(with: direction)(component)(self)
    }
}

//MARK: - Implementations

extension String: Encryptable {

    public static func encrypt(with component: @escaping DirectedComponent) -> ((String) -> String) {
        return { string in
            var scalarView = UnicodeScalarView()
            scalarView.append(contentsOf: string.unicodeScalars.flatMap({ UnicodeScalar(component(Int($0.value))) }))
            return String(scalarView)
        }
    }
    
    public func encrypt(with enigma: EnigmaType) -> String {
        return String(self.characters.encrypt(with: enigma).encrypted)
    }
}

extension Character: Encryptable {

    public static func encrypt(with component: @escaping DirectedComponent) -> ((Character) -> Character) {
        return { char in
            let scalar = component(Int(char.unicodeScalar.value))
            return Character(UnicodeScalar(scalar)!)
        }
    }
}

extension Int: Encryptable {
    public static func encrypt(with component: @escaping DirectedComponent) -> ((Int) -> Int) {
        return component
    }
}
