//
//  Operators.swift
//  
//
//  Created by Eskil Gjerde Sviggum on 09/05/2023.
//

import Foundation

public func ==(lhs: GROQKeyRepresentable, rhs: GROQStringRepresentable) -> GROQWhereField {
    Equal(lhs, rhs)
}

public func !=(lhs: GROQKeyRepresentable, rhs: GROQStringRepresentable) -> GROQWhereField {
    NotEqual(lhs, rhs)
}

public func <(lhs: GROQKeyRepresentable, rhs: GROQStringRepresentable) -> GROQWhereField {
    LessThan(lhs, rhs)
}

public func >(lhs: GROQKeyRepresentable, rhs: GROQStringRepresentable) -> GROQWhereField {
    GreaterThan(lhs, rhs)
}

public func <=(lhs: GROQKeyRepresentable, rhs: GROQStringRepresentable) -> GROQWhereField {
    LessThanOrEqual(lhs, rhs)
}

public func >=(lhs: GROQKeyRepresentable, rhs: GROQStringRepresentable) -> GROQWhereField {
    GreaterThanOrEqual(lhs, rhs)
}

public func ||(lhs: GROQWhereField, rhs: GROQWhereField) -> GROQWhereField {
    _Or([lhs, rhs])
}

public func &&(lhs: GROQWhereField, rhs: GROQWhereField) -> GROQWhereField {
    _And([lhs, rhs])
}

prefix operator !
public prefix func !(field: GROQWhereField) -> GROQWhereField {
    Not(field)
}
