//
//  Range.swift
//  Enigma
//
//  Created by Leonard Mehlig on 03/04/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

extension Range where Element: Comparable {
    func inBounds(index: Element) -> Element {
        if index < self.startIndex {
            return self.inBounds(index.advancedBy(self.count+1))
        } else if index > self.endIndex {
            return self.inBounds(index.advancedBy(-(self.count+1)))
        }
        return index
    }
}