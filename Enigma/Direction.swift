//
//  Direction.swift
//  Enigma
//
//  Created by Leonard Mehlig on 02/04/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

public enum Direction: CustomStringConvertible {
    case In, Out
    
    public var isIn: Bool { return self == .In }
    public var isOut: Bool { return self == .Out }
    
    public func choose<T>(@autoclosure `in`  `in`: () -> T, @autoclosure out: () -> T) -> T {
        switch self {
        case .In: return `in`()
        case .Out: return out()
            
        }
    }
    
    public var description: String {
        switch self {
        case .In: return "In"
        case .Out: return "Out"
        }
    }
}