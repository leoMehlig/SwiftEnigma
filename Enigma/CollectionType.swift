//
//  CollectionType.swift
//  Enigma
//
//  Created by Leonard Mehlig on 25/03/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

extension Collection where Iterator.Element: Encryptable {
    public func encrypt(with enigma: EnigmaType) -> (encrypted: [Iterator.Element], enigma: EnigmaType) {
        return self.reduce((Array<Iterator.Element>(), enigma), { (accu, element) in
            let newEnigma = accu.1.step(by: 1)
            let encrypted = element.encrypt(with: newEnigma)
            return (accu.0 + [encrypted], newEnigma)
        })
    }
}
