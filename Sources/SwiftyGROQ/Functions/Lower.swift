//
//  Lower.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 12/05/2023.
//

import Foundation

public struct LowerField: GROQField, GROQHeterogenicallyConcatenateable {
    
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
        "lower(\(fieldName.groqFieldText))"
    }
    
    public var leftHandSideConcatenatedQroqFieldText: String {
        self.groqFieldText
    }
    
}

public struct LowerWhereField: GROQWhereField, GROQKeyRepresentable, GROQStringRepresentable, GROQHeterogenicallyConcatenateable {
    
    let fieldName: String
    
    init(_ field: GROQKeyRepresentable) {
        self.fieldName = field.groqKeyText
    }
    
    public var groqWhereFieldText: String {
        "lower(\(fieldName))"
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

/// Takes a string and returns the string in all lowercase characters.
public func Lower(newFieldName nameSubstitution: GROQFieldKey, field: GROQField) -> LowerField {
    LowerField(newFieldName: nameSubstitution, field: field)
}

/// Takes a string and returns the string in all lowercase characters.
public func Lower(field: GROQField) -> LowerField {
    LowerField(newFieldName: field.groqFieldText.groqKeySafeRepresentation, field: field)
}

/// Takes a string and returns the string in all lowercase characters.
public func Lower(_ field: GROQKeyRepresentable) -> LowerWhereField {
    LowerWhereField(field)
}
