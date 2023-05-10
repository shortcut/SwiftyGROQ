//
//  GROQKeyRepresentable.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 09/05/2023.
//

import Foundation

public protocol GROQKeyRepresentable {
    var groqKeyText: String { get }
}

extension String: GROQKeyRepresentable {
    public var groqKeyText: String { self }
}

public enum SpecialGROQKey: GROQKeyRepresentable {
    case type
    case id
    case rev
    case createdAt
    case updatedAt
    
    public var groqKeyText: String {
        switch self {
        case .type:
            return "_type"
        case .id:
            return "_id"
        case .rev:
            return "_rev"
        case .createdAt:
            return "_createdAt"
        case .updatedAt:
            return "_updatedAt"
        }
    }
}
