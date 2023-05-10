//
//  GROQField.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 09/05/2023.
//

import Foundation

public protocol GROQFieldKey {
    var groqFieldKeyText: String { get }
}

public protocol GROQField {
    var groqFieldText: String { get }
}

extension String: GROQField, GROQFieldKey {
    public var groqFieldText: String { self }
}

extension SpecialGROQKey: GROQField, GROQFieldKey {
    public var groqFieldText: String { self.groqKeyText }
}

extension GROQFieldKey where Self: GROQField {
    public var groqFieldKeyText: String { groqFieldText }
}

@resultBuilder
public struct GROQFieldBuilder {
    public static func buildBlock(_ components: GROQField...) -> String {
        components
            .map { $0.groqFieldText }
            .enumerated()
            .reduce(into: "") { partialResult, next in
                partialResult += "\n" + next.element + (next.offset != components.endIndex - 1 ? "," : "")
            }
    }
}

/// Provides a way to rename fields.
/// `{ "renamedTo": field }`
public struct Field: GROQField {
    
    let fieldName: GROQField
    let nameSubstitution: String?
    
    public init(renamedTo nameSubstitution: GROQFieldKey?, _ field: GROQField) {
        self.fieldName = field
        self.nameSubstitution = nameSubstitution?.groqFieldKeyText
    }
    
    public init(_ field: GROQField) {
        self.fieldName = field
        self.nameSubstitution = nil
    }
    
    public var groqFieldText: String {
        if let nameSubstitution {
            return "\"\(nameSubstitution)\": \(fieldName.groqFieldText)"
        } else {
            return fieldName.groqFieldText
        }
    }
    
}

/// Provides the number of elements in an array.
/// `{ "newFieldName": count(field) }`
public struct Count: GROQField {
    
    let fieldName: GROQField
    let nameSubstitution: String
    
    public init(newFieldName nameSubstitution: GROQFieldKey, _ field: GROQField) {
        self.fieldName = field
        self.nameSubstitution = nameSubstitution.groqFieldKeyText
    }
    
    public var groqFieldText: String {
        "\"\(nameSubstitution)\": count(\(fieldName.groqFieldText))"
    }
    
}

/// Provides a fallback value if the field does not exist.
/// `{ "newFieldName": coalesce(field, "fallbackValue") }`
public struct Coalesce: GROQField {
    
    let nameSubstitution: String
    let fieldName: GROQField
    let fallbackValue: GROQStringRepresentable
    
    public init(newFieldName nameSubstitution: GROQFieldKey, _ field: GROQField, fallbackValue: GROQStringRepresentable) {
        self.nameSubstitution = nameSubstitution.groqFieldKeyText
        self.fieldName = field
        self.fallbackValue = fallbackValue
    }
    
    public var groqFieldText: String {
        "\"\(nameSubstitution)\": coalesce(\(fieldName.groqFieldText), \(fallbackValue.groqStringValue))"
    }
    
}

/// Explicitly provides all fields.
/// `{ ... }`
public struct All: GROQField {
    
    public var groqFieldText: String {
        "..."
    }
    
    public init() {}
    
}

/// Write text to directly manipulate the query in GROQ.
public struct Custom: GROQField, GROQWhereField {
    
    let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public var groqFieldText: String {
        text
    }
    
    public var groqWhereFieldText: String {
        text
    }
    
}
