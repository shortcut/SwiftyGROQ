//
//  Length.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 12/05/2023.
//

import Foundation

public struct LengthField: GROQField, GROQHeterogenicallyConcatenateable {
    
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
        "length(\(fieldName.groqFieldText))"
    }
    
    public var leftHandSideConcatenatedQroqFieldText: String {
        self.groqFieldText
    }
    
}

public struct LengthWhereField: GROQWhereField, GROQKeyRepresentable, GROQStringRepresentable, GROQHeterogenicallyConcatenateable {
    
    let fieldName: String
    
    init(_ field: GROQKeyRepresentable) {
        self.fieldName = field.groqKeyText
    }
    
    public var groqWhereFieldText: String {
        "length(\(fieldName))"
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

public func Length(newFieldName nameSubstitution: GROQFieldKey, field: GROQField) -> LengthField {
    LengthField(newFieldName: nameSubstitution, field: field)
}

public func Length(field: GROQField) -> LengthField {
    LengthField(newFieldName: field.groqFieldText.groqKeySafeRepresentation, field: field)
}

public func Length(_ field: GROQKeyRepresentable) -> LengthWhereField {
    LengthWhereField(field)
}
