//
//  Range.swift
//  Enigma
//
//  Created by Leonard Mehlig on 03/04/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

extension CountableRange where Bound: Comparable {
    public func inBounds(index: Bound) -> Bound {
        if index < self.startIndex {
            return self.inBounds(index: index.advanced(by: self.count))
        } else if index >= self.endIndex {
            return self.inBounds(index: index.advanced(by: -(self.count)))
        }
        return index
    }
}

extension CountableClosedRange where Bound: Comparable {
    public func inBounds(index: Bound) -> Bound {
        if index < self.lowerBound {
            return self.inBounds(index: index.advanced(by: self.count))
        } else if index > self.upperBound {
            return self.inBounds(index: index.advanced(by: -(self.count)))
        }
        return index
    }
}
