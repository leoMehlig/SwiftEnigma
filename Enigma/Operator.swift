//
//  Operator.swift
//  Enigma
//
//  Created by Leonard Mehlig on 29/03/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

infix operator >>> { associativity left }
func >>> <A, B, C>(f: B -> C, g: A -> B) -> A -> C {
    return { x in f(g(x)) }
}

func + <A: GeneratorType, B: GeneratorType where A.Element == B.Element>(lhs: A, rhs: B) -> AnyGenerator<A.Element> {
    var left = lhs
    var right = rhs
    return AnyGenerator { left.next() ?? right.next() }
}

func + <A: GeneratorType>(lhs: A, rhs: A.Element) -> AnyGenerator<A.Element> {
    var left = lhs
    var right: A.Element? = rhs
    return AnyGenerator {
        if let val = left.next() {
            return val
        } else if let val = right {
            defer { right = nil }
            return val
        }
        return nil
    }
}

func + <A: GeneratorType>(lhs: A.Element, rhs: A) -> AnyGenerator<A.Element> {
    var left: A.Element? = lhs
    var right = rhs
    return AnyGenerator {
        if let val = left {
            defer { left = nil }
            return val
        }
        return right.next()
    }
}
