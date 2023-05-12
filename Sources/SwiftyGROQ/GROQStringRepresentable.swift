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
    
    public func rfc3339String() -> String {
        let formatter = self.rfc3339DateFormatter()
        return formatter.string(from: self)
    }

    /// Date formatters are not thread-safe, so use a thread-local instance
    private func rfc3339DateFormatter() -> DateFormatter {
        let en_US_POSIX = Locale(identifier: "en_US_POSIX")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = en_US_POSIX
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SS'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter
    }

    public var groqStringValue: String {
        self.rfc3339String().groqStringValue }
}

extension Dictionary: GROQStringRepresentable where Key == String, Value == GROQStringRepresentable {
    public var groqStringValue: String {
        do {
            let json = try JSONSerialization.data(withJSONObject: self, options: .sortedKeys)
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

/// A pair of values. Can contain any other GROQ data type.
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

extension Range: GROQStringRepresentable {
    public var groqStringValue: String {
        return "\(lowerBound)...\(upperBound)"
    }
}

extension ClosedRange: GROQStringRepresentable {
    public var groqStringValue: String {
        return "\(lowerBound)..\(upperBound)"
    }
}

extension NSRange: GROQStringRepresentable {
    public var groqStringValue: String {
        return "\(lowerBound)...\(upperBound)"
    }
}

/// Respresents a node or branch in a tree. Can be used to reference a document.
/// Wildcards can be used to match a generic path. `*` can be used to make one level genric, while `**` is multi-level.
public struct Path: GROQStringRepresentable {
    
    let components: [String]
    
    public init(_ components: [String]) {
        self.components = components
    }
    
    public init(_ components: String...) {
        self.components = components
    }
    
    public var groqStringValue: String {
        components
            .enumerated()
            .reduce(into: "\"") { partialResult, next in
                partialResult += next.element + (next.offset != components.count - 1 ? "." : "\"")
            }
    }
}
