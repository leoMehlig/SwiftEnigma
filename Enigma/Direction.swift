//
//  Direction.swift
//  Enigma
//
//  Created by Leonard Mehlig on 02/04/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

public enum Direction: CustomStringConvertible {
    case `in`, out
    
    public var isIn: Bool { return self == .in }
    public var isOut: Bool { return self == .out }
    
    public func choose<T>(`in`: @autoclosure () -> T, out: @autoclosure () -> T) -> T {
        switch self {
        case .in: return `in`()
        case .out: return out()
            
        }
    }
    
    public var description: String {
        switch self {
        case .in: return "In"
        case .out: return "Out"
        }
    }
}
