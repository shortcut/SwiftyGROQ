//
//  Upper.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 12/05/2023.
//

import Foundation

public struct UpperField: GROQField, GROQHeterogenicallyConcatenateable {
    
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
        "upper(\(fieldName.groqFieldText))"
    }
    
    public var leftHandSideConcatenatedQroqFieldText: String {
        self.groqFieldText
    }
    
}

public struct UpperWhereField: GROQWhereField, GROQKeyRepresentable, GROQStringRepresentable, GROQHeterogenicallyConcatenateable {
    
    let fieldName: String
    
    init(_ field: GROQKeyRepresentable) {
        self.fieldName = field.groqKeyText
    }
    
    public var groqWhereFieldText: String {
        "upper(\(fieldName))"
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

/// Takes a string and returns the string in all uppercase characters.
public func Upper(newFieldName nameSubstitution: GROQFieldKey, field: GROQField) -> UpperField {
    UpperField(newFieldName: nameSubstitution, field: field)
}

/// Takes a string and returns the string in all uppercase characters.
public func Upper(field: GROQField) -> UpperField {
    UpperField(newFieldName: field.groqFieldText.groqKeySafeRepresentation, field: field)
}

/// Takes a string and returns the string in all uppercase characters.
public func Upper(_ field: GROQKeyRepresentable) -> UpperWhereField {
    UpperWhereField(field)
}
