//
//  Operator.swift
//  Enigma
//
//  Created by Leonard Mehlig on 29/03/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

infix operator >>> { associativity left }
func >>> <A, B, C>(f: @escaping (B) -> C, g: @escaping (A) -> B) -> (A) -> C {
    return { x in f(g(x)) }
}

func + <A: IteratorProtocol, B: IteratorProtocol>(lhs: A, rhs: B) -> AnyIterator<A.Element> where A.Element == B.Element {
    var left = lhs
    var right = rhs
    return AnyIterator { left.next() ?? right.next() }
}

func + <A: IteratorProtocol>(lhs: A, rhs: A.Element) -> AnyIterator<A.Element> {
    var left = lhs
    var right: A.Element? = rhs
    return AnyIterator {
        if let val = left.next() {
            return val
        } else if let val = right {
            defer { right = nil }
            return val
        }
        return nil
    }
}

func + <A: IteratorProtocol>(lhs: A.Element, rhs: A) -> AnyIterator<A.Element> {
    var left: A.Element? = lhs
    var right = rhs
    return AnyIterator {
        if let val = left {
            defer { left = nil }
            return val
        }
        return right.next()
    }
}
