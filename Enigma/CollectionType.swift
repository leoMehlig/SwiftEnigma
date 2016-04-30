//
//  CollectionType.swift
//  Enigma
//
//  Created by Leonard Mehlig on 25/03/16.
//  Copyright © 2016 Leo Mehlig. All rights reserved.
//

extension CollectionType where Generator.Element: Encryptable {
    public func encrypt(enigma enigma: EnigmaType) -> (encrypted: [Generator.Element], enigma: EnigmaType) {
        return self.reduce((Array<Generator.Element>(), enigma), combine: { (accu, element) in
            let newEnigma = accu.1.step(1)
            let encrypted = element.encrypt(enigma: newEnigma)
            return (accu.0 + [encrypted], newEnigma)
        })
    }
}
