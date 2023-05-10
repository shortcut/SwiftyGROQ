//
//  GROQKeyModifiers.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 10/05/2023.
//

import Foundation

/// Convert to lowercase
/// `lower(key)`
public struct Lower: GROQKeyRepresentable {
    
    let underlyingKey: GROQKeyRepresentable
    
    public init(_ key: GROQKeyRepresentable) {
        self.underlyingKey = key
    }
    
    public var groqKeyText: String {
        "lower(\(underlyingKey.groqKeyText))"
    }
    
}
