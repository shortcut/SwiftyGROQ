//
//  File.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 12/05/2023.
//

import Foundation

extension String {
    
    /// Makes a string which removes any characters not allowed to be in a key.
    /// `(, ), _, "`
    var groqKeySafeRepresentation: String {
        let disallowedCharacters = "()_\""
        return self.filter { !disallowedCharacters.contains($0) }
    }
    
}
