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
    
    let range: Range<Int>
    
    init(`in`: [Int : Int], out: [Int : Int], offset: Int, position: Int, range: Range<Int>, turnover: Int) {
        self.inMap = `in`
        self.outMap = out
        self.offset = range.inBounds(offset)
        self.position = range.inBounds(position)
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
        self.init(in: map, out: out, offset: offset, position: position, range: min..<max, turnover: turnover)
    }
    
    public var relativePosition: Int { return self.position - self.range.startIndex }
    private var relativeOffset: Int { return self.offset - self.range.startIndex }
    
    public func encrypt(direction direction: Direction) -> DirectedComponent {
        return { index in
            let rotated = self.range.inBounds(index + self.relativePosition - self.relativeOffset)
            let encrypted = direction.choose(in: self.inMap[rotated], out: self.outMap[rotated]) ?? rotated
            return self.range.inBounds(encrypted - self.relativePosition + self.relativeOffset)
        }
    }
    
    public func step(n: Int, index: Int) -> (ComponentType, Int) {
        let steps: Int = (index == 1 ? self.extraSecodeRotor(n) : 0) + n
        guard steps > 0 else { return (self, 0) }
        let newPosition = self.range.inBounds(self.position + steps)
        var newRotor = self
        newRotor.position = newPosition
        let next = (newPosition - self.range.startIndex) / (range.count + 1) + ((self.position < self.turnover && (newPosition >= self.turnover) ? 1 : 0))
     
        return (newRotor, next)
    }
    
    private func extraSecodeRotor(n: Int, subtract: Int = 0) -> Int {
        let extraPosition = self.range.inBounds(self.position + max(n - 1, 0))
        let extra = (extraPosition - self.range.startIndex) / (range.count + 1) + ((self.position <= self.turnover - 1 && (extraPosition >= self.turnover - 1) ? 1 : 0)) - subtract
        if extra > 0 {
            return extra + extraSecodeRotor(n + extra, subtract: extra)
        }
        return extra
    }
}

extension RotorComponent {
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
        self.init(in: inMap, out: outMap, offset: Int(offset.unicodeScalar.value), position: min, range: min..<max, turnover: Int(offset.unicodeScalar.value))
        
    }
}

