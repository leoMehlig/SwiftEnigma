//
//  EnigmaImplementations.swift
//  Enigma
//
//  Created by Leonard Mehlig on 29/03/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

public protocol EnigmaType {
    func generateComponents() -> AnyGenerator<DirectedComponent>
    func step(n: Int) -> Self
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
    
    public func generateComponents() -> AnyGenerator<DirectedComponent> {
        return components.map({ $0.encrypt(direction: .In) }).generate() + reflect.encrypt(direction: .In) + components.reverse().map({ $0.encrypt(direction: .Out) }).generate()
    }
    
    public func step(n: Int) -> Enigma {
        return Enigma(
            components: self.components.enumerate().reduce(([ComponentType](), n)) {
                let element = $1.element.step($0.1, index: $1.index)
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
    public func generateComponents() -> AnyGenerator<DirectedComponent> {
        return AnyGenerator(components.map({ $0.encrypt(direction: .In) }).generate())
    }
    
    public func step(n: Int) -> OneWayEnigma {
        return self
    }
}


