//
//  EnigmaImplementations.swift
//  Enigma
//
//  Created by Leonard Mehlig on 29/03/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

public protocol EnigmaType {
    var componentIterator: AnyIterator<DirectedComponent> { get }
    func step(by steps: Int) -> Self
}

//MARK: - Implementations

public struct Enigma: EnigmaType {
    public let components: [ComponentType]
    public let reflect: ComponentType
    
    public init(components: [ComponentType], reflect: ComponentType) {
        self.components = components
        self.reflect = reflect
    }
    
    public init?(components: [ComponentType]) {
        guard let reflect = components.last else { return nil }
        self.init(components: Array(components.dropLast()), reflect: reflect)
    }
    
    public var componentIterator: AnyIterator<DirectedComponent> {
         return components.map({ $0.encrypt(with: .in) }).makeIterator() + reflect.encrypt(with: .in) + components.reversed().map({ $0.encrypt(with: .out) }).makeIterator()
    }
    public func step(by steps: Int) -> Enigma {
        return Enigma(
            components: self.components.enumerated().reduce(([ComponentType](), steps)) {
                let element = $1.element.step(by: $0.1, atPosition: $1.offset)
                return ($0.0 + [element.0], element.1)
            }.0,
            reflect: self.reflect)
    }
}

public struct OneWayEnigma: EnigmaType {
    let components: [ComponentType]
    
    public init(components: [ComponentType]) {
        self.components = components
    }
    public var componentIterator: AnyIterator<DirectedComponent> {
        return AnyIterator(components.map({ $0.encrypt(with: .in) }).makeIterator())
    }
    
    public func step(by steps: Int) -> OneWayEnigma {
        return self
    }
}


