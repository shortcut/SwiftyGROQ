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
            return NSNull().groqStringValue
        }
        
        return "\(self)"
    }
}

extension Float: GROQStringRepresentable {
    public var groqStringValue: String {
        if !self.isFinite {
            Logger.warn(.floatValueIsNotFinite)
            return NSNull().groqStringValue
        }
        
        return "\(self)"
    }
}

extension NSNull: GROQStringRepresentable {
    public var groqStringValue: String { "null" }
}

extension Optional: GROQStringRepresentable where Wrapped == GROQStringRepresentable {
    public var groqStringValue: String {
        self.map { $0.groqStringValue } ?? NSNull().groqStringValue
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

extension Dictionary: GROQStringRepresentable where Key == String, Value == GROQStringRepresentable {
    public var groqStringValue: String {
        do {
            let json = try JSONSerialization.data(withJSONObject: self)
            guard let text = String(data: json, encoding: .utf8) else {
                Logger.warn(.cannotEncodeDictionary(nil))
                return "{}"
            }
            return text
        } catch {
            Logger.warn(.cannotEncodeDictionary(error))
            return "{}"
        }
    }
}

public struct Pair<L: GROQStringRepresentable, R: GROQStringRepresentable>: GROQStringRepresentable {
    
    let left: L
    let right: R
    
    public init(_ left: L, _ right: R) {
        self.left = left
        self.right = right
    }
    
    public init(_ tuple: (left: L, right: R)) {
        self.left = tuple.left
        self.right = tuple.right
    }
    
    public var groqStringValue: String {
        "\(left.groqStringValue) => \(right.groqStringValue)"
    }
}
