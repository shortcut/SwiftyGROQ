//
//  GROQField.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 09/05/2023.
//

import Foundation

protocol GROQFieldKey {
    var groqFieldKeyText: String { get }
}

protocol GROQField {
    var groqFieldText: String { get }
}

extension String: GROQField, GROQFieldKey {
    var groqFieldText: String { self }
}

extension SpecialGROQKey: GROQField, GROQFieldKey {
    var groqFieldText: String { self.groqKeyText }
}

extension GROQFieldKey where Self: GROQField {
    var groqFieldKeyText: String { groqFieldText }
}

@resultBuilder
struct GROQFieldBuilder {
    static func buildBlock(_ components: GROQField...) -> String {
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
struct Field: GROQField {
    
    let fieldName: GROQField
    let nameSubstitution: String?
    
    init(renamedTo nameSubstitution: GROQFieldKey?, _ field: GROQField) {
        self.fieldName = field
        self.nameSubstitution = nameSubstitution?.groqFieldKeyText
    }
    
    init(_ field: GROQField) {
        self.fieldName = field
        self.nameSubstitution = nil
    }
    
    var groqFieldText: String {
        if let nameSubstitution {
            return "\"\(nameSubstitution)\": \(fieldName.groqFieldText)"
        } else {
            return fieldName.groqFieldText
        }
    }
    
}

/// Provides the number of elements in an array.
/// `{ "newFieldName": count(field) }`
struct Count: GROQField {
    
    let fieldName: GROQField
    let nameSubstitution: String
    
    init(newFieldName nameSubstitution: GROQFieldKey, _ field: GROQField) {
        self.fieldName = field
        self.nameSubstitution = nameSubstitution.groqFieldKeyText
    }
    
    var groqFieldText: String {
        "\"\(nameSubstitution)\": count(\(fieldName.groqFieldText))"
    }
    
}

/// Provides a fallback value if the field does not exist.
/// `{ "newFieldName": coalesce(field, "fallbackValue") }`
struct Coalesce: GROQField {
    
    let nameSubstitution: String
    let fieldName: GROQField
    let fallbackValue: GROQStringRepresentable
    
    init(newFieldName nameSubstitution: GROQFieldKey, _ field: GROQField, fallbackValue: GROQStringRepresentable) {
        self.nameSubstitution = nameSubstitution.groqFieldKeyText
        self.fieldName = field
        self.fallbackValue = fallbackValue
    }
    
    var groqFieldText: String {
        "\"\(nameSubstitution)\": coalesce(\(fieldName.groqFieldText), \(fallbackValue.groqStringValue))"
    }
    
}

/// Explicitly provides all fields.
/// `{ ... }`
struct All: GROQField {
    
    var groqFieldText: String {
        "..."
    }
    
}

struct Custom: GROQField, GROQWhereField {
    
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var groqFieldText: String {
        text
    }
    
    var groqWhereFieldText: String {
        text
    }
    
}
