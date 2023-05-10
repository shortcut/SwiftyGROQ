//
//  GROQKeyModifiers.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 10/05/2023.
//

import Foundation

struct Lower: GROQKeyRepresentable {
    
    let underlyingKey: GROQKeyRepresentable
    
    init(_ key: GROQKeyRepresentable) {
        self.underlyingKey = key
    }
    
    var groqKeyText: String {
        "lower(\(underlyingKey.groqKeyText))"
    }
    
}
