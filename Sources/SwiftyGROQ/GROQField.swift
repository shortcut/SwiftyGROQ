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
    let fallbackFields: [GROQField]
    let fallbackValue: GROQStringRepresentable
    
    public init(newFieldName nameSubstitution: GROQFieldKey, field: GROQField, fallbackValue: GROQStringRepresentable) {
        self.nameSubstitution = nameSubstitution.groqFieldKeyText
        self.fieldName = field
        self.fallbackValue = fallbackValue
        self.fallbackFields = []
    }
    
    public init(newFieldName nameSubstitution: GROQFieldKey, field: GROQField, fallbackFields: [GROQField], fallbackValue: GROQStringRepresentable) {
        self.nameSubstitution = nameSubstitution.groqFieldKeyText
        self.fieldName = field
        self.fallbackValue = fallbackValue
        self.fallbackFields = fallbackFields
    }
    
    public var groqFieldText: String {
        let fallbackKeysString = self.fallbackFields.isEmpty ? "" : ", " + self.fallbackFields
            .map { $0.groqFieldText }
            .joined(separator: ", ")
        return "\"\(nameSubstitution)\": coalesce(\(fieldName.groqFieldText)\(fallbackKeysString), \(fallbackValue.groqStringValue))"
    }
    
}

public struct DateTimeField: GROQField, GROQHeterogenicallyConcatenateable {
    
    let nameSubstitution: String
    let fieldName: GROQField
    
    init(newFieldName nameSubstitution: GROQFieldKey, field: GROQField) {
        self.nameSubstitution = nameSubstitution.groqFieldKeyText
        self.fieldName = field
    }
    
    public var groqFieldText: String {
        "\"\(nameSubstitution)\": \(rightHandSideConcatenatedQroqFieldText)"
    }
    
    public var rightHandSideConcatenatedQroqFieldText: String {
        "dateTime(\(fieldName.groqFieldText))"
    }
    
    public var leftHandSideConcatenatedQroqFieldText: String {
        self.groqFieldText
    }
    
}

public struct DateTimeWhereField: GROQWhereField, GROQKeyRepresentable, GROQStringRepresentable, GROQHeterogenicallyConcatenateable {
    
    let fieldName: String
    
    init(_ field: GROQKeyRepresentable) {
        self.fieldName = field.groqKeyText
    }
    
    public var groqWhereFieldText: String {
        "dateTime(\(fieldName))"
    }
    
    public var groqKeyText: String {
        self.groqWhereFieldText
    }
    
    public var groqStringValue: String {
        self.groqWhereFieldText
    }
    
    public var rightHandSideConcatenatedQroqFieldText: String {
        self.groqStringValue
    }
    
    public var leftHandSideConcatenatedQroqFieldText: String {
        self.groqStringValue
    }
    
}

public func DateTime(newFieldName nameSubstitution: GROQFieldKey, field: GROQField) -> DateTimeField {
    DateTimeField(newFieldName: nameSubstitution, field: field)
}

public func DateTime(field: GROQField) -> DateTimeField {
    DateTimeField(newFieldName: field.groqFieldText.replacingOccurrences(of: "\"", with: ""), field: field)
}

public func DateTime(_ field: GROQKeyRepresentable) -> DateTimeWhereField {
    DateTimeWhereField(field)
}

/// Explicitly provides all fields.
/// `{ ... }`
public struct All: GROQField {
    
    public var groqFieldText: String {
        "..."
    }
    
    public init() {}
    
}

/// Provides the current date
/// `now()`
public struct Now: GROQField, GROQKeyRepresentable, GROQStringRepresentable, GROQWhereField {
    
    public var groqFieldText: String {
        "now()"
    }
    
    public var groqKeyText: String {
        self.groqFieldText
    }
    
    public var groqStringValue: String {
        self.groqFieldText
    }
    
    public var groqWhereFieldText: String {
        self.groqFieldText
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
