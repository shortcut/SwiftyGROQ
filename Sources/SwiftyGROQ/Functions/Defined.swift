//
//  Defined.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 12/05/2023.
//

import Foundation

public struct DefinedField: GROQField {
    
    let nameSubstitution: String
    let fieldName: GROQField
    
    init(newFieldName nameSubstitution: GROQFieldKey, field: GROQField) {
        self.nameSubstitution = nameSubstitution.groqFieldKeyText
        self.fieldName = field
    }
    
    public var groqFieldText: String {
        "\"\(nameSubstitution)\": defined(\(fieldName.groqFieldText))"
    }
    
}

public struct DefinedWhereField: GROQWhereField {
    
    let fieldName: String
    
    init(_ field: GROQKeyRepresentable) {
        self.fieldName = field.groqKeyText
    }
    
    public var groqWhereFieldText: String {
        "defined(\(fieldName))"
    }
    
}

/// Returns `true` if the argument is non-`null`, otherwise `false`.
public func Defined(newFieldName nameSubstitution: GROQFieldKey, field: GROQField) -> DefinedField {
    DefinedField(newFieldName: nameSubstitution, field: field)
}

/// Returns `true` if the argument is non-`null`, otherwise `false`.
public func Defined(field: GROQField) -> DefinedField {
    DefinedField(newFieldName: field.groqFieldText.groqKeySafeRepresentation, field: field)
}

/// Returns `true` if the argument is non-`null`, otherwise `false`.
public func Defined(_ field: GROQKeyRepresentable) -> DefinedWhereField {
    DefinedWhereField(field)
}
