//
//  Identity.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 12/05/2023.
//

import Foundation

public struct IdentityField: GROQField {
    
    let nameSubstitution: String
    
    init(newFieldName nameSubstitution: GROQFieldKey) {
        self.nameSubstitution = nameSubstitution.groqFieldKeyText
    }
    
    public var groqFieldText: String {
        "\"\(nameSubstitution)\": identity()"
    }
    
}

public struct IdentityWhereField: GROQWhereField {
    
    public var groqWhereFieldText: String {
        "identity()"
    }
    
}

/// Returns the identity (user ID) of the user performing the current action,
/// or the special values `<anonymous>` for unauthenticated users
/// and `<system>` for system-initiated actions.
public func Identity(newFieldName nameSubstitution: GROQFieldKey) -> IdentityField {
    IdentityField(newFieldName: nameSubstitution)
}

/// Returns the identity (user ID) of the user performing the current action,
/// or the special values `<anonymous>` for unauthenticated users
/// and `<system>` for system-initiated actions.
public func Identity() -> IdentityWhereField {
    IdentityWhereField()
}

