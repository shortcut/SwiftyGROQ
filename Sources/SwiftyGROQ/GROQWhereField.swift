//
//  GROQWhereField.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 09/05/2023.
//

import Foundation

public protocol GROQWhereField {
    var groqWhereFieldText: String { get }
}

public protocol GROQueryRootField {
    var attachKeyPath: String { get }
    var isArray: Bool { get }
}

extension GROQueryRootField {
    public var isArray: Bool { false }
}

struct NilGROQField: GROQWhereField {
    var groqWhereFieldText: String { "" }
}

struct _And: GROQWhereField {
    let fields: [any GROQWhereField]
    
    var groqWhereFieldText: String {
        fields
            .map { $0.groqWhereFieldText }
            .enumerated()
            .reduce(into: "") { partialResult, field in
                partialResult += field.element + (field.offset == fields.indices.upperBound - 1 ? "" : " && ")
            }
    }
    
    init(_ fields: [any GROQWhereField]) {
        self.fields = fields
    }
}

struct _Or: GROQWhereField {
    let fields: [GROQWhereField]
    
    var groqWhereFieldText: String {
        fields
            .map { $0.groqWhereFieldText }
            .enumerated()
            .reduce(into: "") { partialResult, field in
                partialResult += field.element + (field.offset == fields.indices.upperBound - 1 ? "" : " || ")
            }
    }
    
    init(_ fields: [GROQWhereField]) {
        self.fields = fields
    }
}

struct _Not: GROQWhereField {
    let fields: [GROQWhereField]
    
    var groqWhereFieldText: String {
        "!(\(_And(fields).groqWhereFieldText))"
    }
    
    init(_ fields: [GROQWhereField]) {
        self.fields = fields
    }
}

@resultBuilder
public struct GROQueryBuilder {
    public static func buildBlock(_ components: GROQWhereField...) -> (GROQWhereField, [any GROQueryRootField]) {
        var setFields = [any GROQueryRootField]()
        let queryComponents = components.compactMap { component -> GROQWhereField? in
            if let component = component as? (any GROQueryRootField) {
                setFields.append(component)
                return nil
            }
            
            return component
        }
        
        return (_And(queryComponents), setFields)
    }
}

@resultBuilder
public struct GROQFieldAndBuilder {
    public static func buildBlock(_ components: GROQWhereField...) -> GROQWhereField {
        _And(components)
    }
}

@resultBuilder
public struct GROQFieldOrBuilder {
    public static func buildBlock(_ components: GROQWhereField...) -> GROQWhereField {
        _Or(components)
    }
}

@resultBuilder
public struct GROQFieldNotBuilder {
    public static func buildBlock(_ components: GROQWhereField...) -> GROQWhereField {
        _Not(components)
    }
}

/// Select a specific type.
public struct `Type`: GROQWhereField {
    
    let typeName: String
    
    public var groqWhereFieldText: String {
        "_type == \"\(typeName)\""
    }
    
    public init(_ typeName: String) {
        self.typeName = typeName
    }
}

/// Filter by a field being truthy.
public struct True: GROQWhereField {
    
    let fieldName: String
    
    public var groqWhereFieldText: String {
        fieldName
    }
    
    public init(_ fieldName: String) {
        self.fieldName = fieldName
    }
}

/// `&&` | Concatenate filters using the AND operator
public struct And: GROQWhereField {
    var fields: any GROQWhereField
    
    public init(@GROQFieldAndBuilder fields: () -> any GROQWhereField) {
        self.fields = fields()
    }
    
    public var groqWhereFieldText: String {
        fields.groqWhereFieldText
    }
}

/// `||` | Concatenate filters using the OR operator.
public struct Or: GROQWhereField {
    var fields: GROQWhereField
    
    public init(@GROQFieldOrBuilder fields: () -> any GROQWhereField) {
        self.fields = fields()
    }
    
    public var groqWhereFieldText: String {
        fields.groqWhereFieldText
    }
}

/// `!` | Negate a filter, several filters are concatenated with `&&`.
public struct Not: GROQWhereField {
    var fields: any GROQWhereField
    
    public init(@GROQFieldNotBuilder fields: () -> any GROQWhereField) {
        self.fields = fields()
    }
    
    public init(_ field: any GROQWhereField) {
        self.fields = _Not([field])
    }
    
    public var groqWhereFieldText: String {
        fields.groqWhereFieldText
    }
}

/// `==` | Filter by the left hand side equalling the right hand side element
public struct Equal: GROQWhereField {
    
    static let infixOperator = "=="
    let variable: String
    let value: String
    
    public var groqWhereFieldText: String {
        "\(variable) \(Self.infixOperator) \(value)"
    }
    
    public init(_ variable: GROQKeyRepresentable, _ value: GROQStringRepresentable) {
        self.variable = variable.groqKeyText
        self.value = value.groqStringValue
    }
}

/// `!=` | Filter by the left hand side not equalling the right hand side element
public struct NotEqual: GROQWhereField {
    
    static let infixOperator = "!="
    let variable: String
    let value: String
    
    public var groqWhereFieldText: String {
        "\(variable) \(Self.infixOperator) \(value)"
    }
    
    public init(_ variable: GROQKeyRepresentable, _ value: GROQStringRepresentable) {
        self.variable = variable.groqKeyText
        self.value = value.groqStringValue
    }
}

/// `<` | Filter by the left hand side being less than the right hand side element
public struct LessThan: GROQWhereField {
    
    static let infixOperator = "<"
    let variable: String
    let value: String
    
    public var groqWhereFieldText: String {
        "\(variable) \(Self.infixOperator) \(value)"
    }
    
    public init(_ variable: GROQKeyRepresentable, _ value: GROQStringRepresentable) {
        self.variable = variable.groqKeyText
        self.value = value.groqStringValue
    }
}

/// `>` | Filter by the left hand side being greater than the right hand side element
public struct GreaterThan: GROQWhereField {
    
    static let infixOperator = ">"
    let variable: String
    let value: String
    
    public var groqWhereFieldText: String {
        "\(variable) \(Self.infixOperator) \(value)"
    }
    
    public init(_ variable: GROQKeyRepresentable, _ value: GROQStringRepresentable) {
        self.variable = variable.groqKeyText
        self.value = value.groqStringValue
    }
}

/// `<=` | Filter by the left hand side being less than or equal the right hand side element
public struct LessThanOrEqual: GROQWhereField {
    
    static let infixOperator = "<="
    let variable: String
    let value: String
    
    public var groqWhereFieldText: String {
        "\(variable) \(Self.infixOperator) \(value)"
    }
    
    public init(_ variable: GROQKeyRepresentable, _ value: GROQStringRepresentable) {
        self.variable = variable.groqKeyText
        self.value = value.groqStringValue
    }
}

/// `>=` | Filter by the left hand side being greater than or equal to the right hand side element
public struct GreaterThanOrEqual: GROQWhereField {
    
    static let infixOperator = ">="
    let variable: String
    let value: String
    
    public var groqWhereFieldText: String {
        "\(variable) \(Self.infixOperator) \(value)"
    }
    
    public init(_ variable: GROQKeyRepresentable, _ value: GROQStringRepresentable) {
        self.variable = variable.groqKeyText
        self.value = value.groqStringValue
    }
}

/// `in` | Filter by the left hand side existing in the set of right hand side elements
public struct In: GROQWhereField {
    
    static let infixOperator = "in"
    let variable: String
    let value: String
    
    public var groqWhereFieldText: String {
        "\(variable) \(Self.infixOperator) \(value)"
    }
    
    public init(_ variable: GROQKeyRepresentable, _ value: Array<GROQStringRepresentable>) {
        self.variable = variable.groqKeyText
        self.value = value.groqStringValue
    }
}

/// `match` | Filter by text matching a certain pattern
public struct Match: GROQWhereField {
    
    static let infixOperator = "match"
    let variable: String
    let value: String
    
    public var groqWhereFieldText: String {
        "\(variable) \(Self.infixOperator) \(value)"
    }
    
    public init(_ variable: GROQKeyRepresentable, _ value: String) {
        self.variable = variable.groqKeyText
        self.value = value.groqStringValue
    }
}

/// Slice the query by setting a lower and upper bound to perform paginated requests.
public enum Slice: GROQWhereField, GROQueryRootField {
    case inclusive(Int, Int)
    case exclusive(Int, Int)
    case single(Int)
    case all
    
    public init(_ range: Range<Int>) {
        self = .exclusive(range.lowerBound, range.upperBound)
    }
    
    public init(_ range: ClosedRange<Int>) {
        self = .inclusive(range.lowerBound, range.upperBound)
    }
    
    public init(_ singleIndex: Int) {
        self = .single(singleIndex)
    }
    
    public var groqWhereFieldText: String {
        switch self {
        case .inclusive(let lower, let upper):
            return "[\(lower)..\(upper)]"
        case .exclusive(let lower, let upper):
            return "[\(lower)...\(upper)]"
        case .single(let index):
            return "[\(index)]"
        case .all:
            return ""
        }
    }
    
    public var attachKeyPath: String { "underlyingSlice" }
}

public struct Order: GROQWhereField, GROQueryRootField {
    
    let variable: String
    let direction: String
    
    public var groqWhereFieldText: String {
        " | order(\(variable) \(direction))"
    }
    
    public init(_ variable: GROQKeyRepresentable,_ direction: Direction = .ascending) {
        self.variable = variable.groqKeyText
        self.direction = direction.rawValue
    }
    
    public enum Direction: String {
        case ascending = "asc"
        case descending = "desc"
    }
    
    public var attachKeyPath: String { "underlyingOrder" }
    public var isArray: Bool { true }
}
