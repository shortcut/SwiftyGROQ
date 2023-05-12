//
//  ToString.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 12/05/2023.
//

import Foundation

public struct ToStringField: GROQField, GROQHeterogenicallyConcatenateable {
    
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
        "string(\(fieldName.groqFieldText))"
    }
    
    public var leftHandSideConcatenatedQroqFieldText: String {
        self.groqFieldText
    }
    
}

public struct ToStringWhereField: GROQWhereField, GROQKeyRepresentable, GROQStringRepresentable, GROQHeterogenicallyConcatenateable {
    
    let fieldName: String
    
    init(_ field: GROQKeyRepresentable) {
        self.fieldName = field.groqKeyText
    }
    
    public var groqWhereFieldText: String {
        "string(\(fieldName))"
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

/// Returns the string representation of a given scalar value.
public func ToString(newFieldName nameSubstitution: GROQFieldKey, field: GROQField) -> ToStringField {
    ToStringField(newFieldName: nameSubstitution, field: field)
}

/// Returns the string representation of a given scalar value.
public func ToString(field: GROQField) -> ToStringField {
    ToStringField(newFieldName: field.groqFieldText.groqKeySafeRepresentation, field: field)
}

/// Returns the string representation of a given scalar value.
public func ToString(_ field: GROQKeyRepresentable) -> ToStringWhereField {
    ToStringWhereField(field)
}
