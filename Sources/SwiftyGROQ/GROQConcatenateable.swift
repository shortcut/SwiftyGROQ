//
//  GROQConcatenateable.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 12/05/2023.
//

import Foundation

public protocol GROQConcatenateable {
    var leftHandSideConcatenatedQroqFieldText: String { get }
    var rightHandSideConcatenatedQroqFieldText: String { get }
}

extension Int: GROQConcatenateable {
    public var leftHandSideConcatenatedQroqFieldText: String {
        self.groqStringValue
    }
    
    public var rightHandSideConcatenatedQroqFieldText: String {
        self.groqStringValue
    }
}

extension String: GROQConcatenateable {
    public var leftHandSideConcatenatedQroqFieldText: String {
        self.groqStringValue
    }
    
    public var rightHandSideConcatenatedQroqFieldText: String {
        self.groqStringValue
    }
}

public protocol GROQHomogenicallyConcatenateable: GROQConcatenateable {
    func adding(_ other: Self) -> ConcatenatedGROQField<Self, Self>
    func subtracting(_ other: Self) -> ConcatenatedGROQField<Self, Self>
}

public protocol GROQHeterogenicallyConcatenateable: GROQConcatenateable {
    func adding<Field: GROQConcatenateable>(_ other: Field) -> ConcatenatedGROQField<Self, Field>
    func subtracting<Field: GROQConcatenateable>(_ other: Field) -> ConcatenatedGROQField<Self, Field>
}

extension GROQHomogenicallyConcatenateable {
    public func adding(_ other: Self) -> ConcatenatedGROQField<Self, Self> {
        ConcatenatedGROQField.added(lhs: self, rhs: other)
    }
    
    public func subtracting(_ other: Self) -> ConcatenatedGROQField<Self, Self> {
        ConcatenatedGROQField.subtracted(lhs: self, rhs: other)
    }
}

extension GROQHeterogenicallyConcatenateable {
    public func adding<Field: GROQConcatenateable>(_ other: Field) -> ConcatenatedGROQField<Self, Field> {
        ConcatenatedGROQField.added(lhs: self, rhs: other)
    }
    
    public func subtracting<Field: GROQConcatenateable>(_ other: Field) -> ConcatenatedGROQField<Self, Field> {
        ConcatenatedGROQField.subtracted(lhs: self, rhs: other)
    }
}

public struct ConcatenatedGROQField<T: GROQConcatenateable, U: GROQConcatenateable>: GROQField, GROQStringRepresentable, GROQKeyRepresentable {
    let concatenationOperator: String
    let lhs: T
    let rhs: U
    
    init(concatenationOperator: String, lhs: T, rhs: U) {
        self.concatenationOperator = concatenationOperator
        self.lhs = lhs
        self.rhs = rhs
    }
    
    public static func added(lhs: T, rhs: U) -> Self {
        ConcatenatedGROQField(concatenationOperator: "+", lhs: lhs, rhs: rhs)
    }
    
    public static func subtracted(lhs: T, rhs: U) -> Self {
        ConcatenatedGROQField(concatenationOperator: "-", lhs: lhs, rhs: rhs)
    }
    
    public var groqFieldText: String {
        "\(lhs.leftHandSideConcatenatedQroqFieldText) \(concatenationOperator) \(rhs.rightHandSideConcatenatedQroqFieldText)"
    }
    
    public var groqStringValue: String {
        self.groqFieldText
    }
    
    public var groqKeyText: String {
        self.groqFieldText
    }
}

public func +<T: GROQHomogenicallyConcatenateable>(lhs: T, rhs: T) -> ConcatenatedGROQField<T, T> {
    lhs.adding(rhs)
}

public func -<T: GROQHomogenicallyConcatenateable>(lhs: T, rhs: T) -> ConcatenatedGROQField<T, T> {
    lhs.subtracting(rhs)
}

public func +<T: GROQHeterogenicallyConcatenateable, U: GROQConcatenateable>(lhs: T, rhs: U) -> ConcatenatedGROQField<T, U> {
    lhs.adding(rhs)
}

public func -<T: GROQHeterogenicallyConcatenateable, U: GROQConcatenateable>(lhs: T, rhs: U) -> ConcatenatedGROQField<T, U> {
    lhs.subtracting(rhs)
}
