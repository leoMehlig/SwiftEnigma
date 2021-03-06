//
//  Rotor.swift
//  Enigma
//
//  Created by Leonard Mehlig on 05/04/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

public struct RotorComponent: ComponentType {
    let inMap: [Int : Int]
    let outMap: [Int : Int]
    
    public let offset: Int
    public private(set) var position: Int
    public let turnover: Int
    
    let range: CountableClosedRange<Int>
    
    init(in: [Int : Int], out: [Int : Int], offset: Int, position: Int, range: CountableClosedRange<Int>, turnover: Int) {
        self.inMap = `in`
        self.outMap = out
        self.offset = range.inBounds(index: offset)
        self.position = range.inBounds(index: position)
        self.range = range
        self.turnover = turnover
    }
    
    public init(map: [Int : Int], offset: Int, position: Int, turnover: Int) {
        var min = Int.max
        var max = Int.min
        var out = [Int : Int]()
        for (key, val) in map {
            if min > key { min = key }
            if min > val { min = val }
            if max < key { max = key }
            if max < val { max = val }
            out[val] = key
        }
        if min == Int.max { min = 0 }
        if max == Int.min { max = 0 }
        self.init(in: map, out: out, offset: offset, position: position, range: min...max, turnover: turnover)
    }
    
    public init(connections: [Character : Character], offset: Character, turnover: Character) {
        var inMap = [Int : Int]()
        var outMap = [Int : Int]()
        var min = Int.max
        var max = Int.min
        for (key, val) in connections {
            let a = Int(key.unicodeScalar.value)
            let b = Int(val.unicodeScalar.value)
            if min > a { min = a }
            if min > b { min = b }
            if max < a { max = a }
            if max < b { max = b }
            inMap[a] = b
            outMap[b] = a
        }
        if min == Int.max { min = 0 }
        if max == Int.min { max = 0 }
        self.init(in: inMap, out: outMap, offset: Int(offset.unicodeScalar.value), position: min, range: min...max, turnover: Int(offset.unicodeScalar.value))
        
    }
    
    public var relativePosition: Int { return self.position - self.range.lowerBound }
    private var relativeOffset: Int { return self.offset - self.range.lowerBound }
    
    public func encrypt(with direction: Direction) -> DirectedComponent {
        return { index in
            let rotated = self.range.inBounds(index: index + self.relativePosition - self.relativeOffset)
            let encrypted = direction.choose(in: self.inMap[rotated], out: self.outMap[rotated]) ?? rotated
            return self.range.inBounds(index: encrypted - self.relativePosition + self.relativeOffset)
        }
    }
    
    public func step(by steps: Int, atPosition: Int) -> (ComponentType, Int) {
        let realSteps: Int = (atPosition == 1 ? self.extraSecodeRotor(with: steps) : 0) + steps
        guard realSteps > 0 else { return (self, 0) }
        let newPosition = self.range.inBounds(index: self.position + realSteps)
        var newRotor = self
        newRotor.position = newPosition
        let next = (newPosition - self.range.lowerBound) / (range.count + 1) + ((self.position < self.turnover && (newPosition >= self.turnover) ? 1 : 0))
     
        return (newRotor, next)
    }
    
    fileprivate func extraSecodeRotor(with steps: Int, subtract: Int = 0) -> Int {
        let extraPosition = self.range.inBounds(index: self.position + max(steps - 1, 0))
        let extra = (extraPosition - self.range.lowerBound) / (range.count + 1) + ((self.position <= self.turnover - 1 && (extraPosition >= self.turnover - 1) ? 1 : 0)) - subtract
        if extra > 0 {
            return extra + extraSecodeRotor(with: steps + extra, subtract: extra)
        }
        return extra
    }
}
