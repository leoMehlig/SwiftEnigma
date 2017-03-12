//
//  ComponentImplementations.swift
//  Enigma
//
//  Created by Leonard Mehlig on 29/03/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

public typealias DirectedComponent = ((Int) -> Int)

public protocol ComponentType {
    func encrypt(direction: Direction) -> DirectedComponent
    func step(_ n: Int, index: Int) -> (ComponentType, Int)

}

extension ComponentType {
    public func step(_ n: Int, index: Int) -> (ComponentType, Int) {
        return (self, n)
    }
}

//MARK: - Implementations


public struct AnyComponent: ComponentType {
    let body: (Direction) -> DirectedComponent
    
    public init(_ body: @escaping (Direction) -> DirectedComponent) {
        self.body = body
    }
    
    public init(in: @escaping DirectedComponent, out: @escaping DirectedComponent) {
        self.body = { dir in
            { dir.choose(in: `in`($0), out: out($0)) }
        }
    }
    
    public func encrypt(direction: Direction) -> DirectedComponent {
        return self.body(direction)
    }
  
}

public struct AnySteppableComponent: ComponentType {
    let base: ComponentType
    let stepper: (Int, Int) -> (AnySteppableComponent, Int)
    
    public init(_ base: ComponentType, stepper: @escaping (Int, Int) -> (AnySteppableComponent, Int)) {
        self.base = base
        self.stepper = stepper
    }
    
    public func encrypt(direction: Direction) -> DirectedComponent {
        return base.encrypt(direction: direction)
    }
    
    public func step(_ n: Int, index: Int) -> (AnySteppableComponent, Int) {
        return stepper(n, index)
    }
  
}

public struct MapComponent: ComponentType {
    fileprivate let inMap: [Int : Int]
    fileprivate let outMap: [Int : Int]
    
    public init(map: [Int : Int]) {
        var new = [Int : Int]()
        for (key, val) in map {
            new[val] = key
        }
        self.init(inMap: map, out: new)
    }
    
    public init(inMap: [Int : Int], out: [Int : Int]) {
        self.inMap = inMap
        self.outMap = out
    }
    
    public func encrypt(direction: Direction) -> DirectedComponent {
        return {
            direction.choose(in: self.inMap[$0], out: self.outMap[$0]) ?? $0
        }
    }
}

extension MapComponent {
    public init(pairs: [(Character, Character)]) {
        var map = [Int : Int]()
        for pair in pairs {
            let a = Int(pair.0.unicodeScalar.value)
            let b = Int(pair.1.unicodeScalar.value)
            map[a] = b
            map[b] = a
        }
        self.init(inMap: map, out: map)
    }
    
    public init(map: [Character : Character]) {
        var intMap = [Int : Int]()
        for (key, val) in map {
            let a = Int(key.unicodeScalar.value)
            let b = Int(val.unicodeScalar.value)
            intMap[a] = b
            intMap[b] = a
        }
        self.init(inMap: intMap, out: intMap)
    }
}

public struct SameComponent: ComponentType {
    public init() { }
    public func encrypt(direction _: Direction) -> DirectedComponent {
        return { $0 }
    }
}


public struct SuccessComponent: ComponentType {
    let success: Int
    
    public init(success: Int) {
        self.success = success
    }
    
    public func encrypt(direction: Direction) -> DirectedComponent {
        return { index in
            return (0..<self.success).reduce(index, { direction.choose(in: ($0.0 + 1), out: ($0.0 - 1)) })
        }
    }
}
