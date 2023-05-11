//
//  GROQStringRepresentable.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 09/05/2023.
//

import Foundation

// MARK: Data Types

public protocol GROQStringRepresentable {
    var groqStringValue: String { get }
}

extension String: GROQStringRepresentable {
    public var groqStringValue: String { "\"\(self)\"" }
}

extension Int: GROQStringRepresentable {
    public var groqStringValue: String { "\(self)" }
}

extension Double: GROQStringRepresentable {
    public var groqStringValue: String {
        if !self.isFinite {
            Logger.warn(.floatValueIsNotFinite)
            return "null"
        }
        
        return "\(self)"
    }
}

extension Float: GROQStringRepresentable {
    public var groqStringValue: String {
        if !self.isFinite {
            Logger.warn(.floatValueIsNotFinite)
            return "null"
        }
        
        return "\(self)"
    }
}

extension Bool: GROQStringRepresentable {
    public var groqStringValue: String { "\(self)" }
}

extension Array: GROQStringRepresentable where Element == GROQStringRepresentable {
    public var groqStringValue: String {
        self
            .map { $0.groqStringValue }
            .enumerated()
            .reduce(into: "[") { partialResult, next in
                partialResult += next.element + (next.offset != self.endIndex - 1 ? ", " : "]")
            }
    }
}

extension Date: GROQStringRepresentable {
    public var groqStringValue: String { ISO8601DateFormatter().string(from: self).groqStringValue }
}
