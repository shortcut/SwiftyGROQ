//
//  GROQuery+Modifiers.swift
//  SwiftyGROQ
//
//  Created by Eskil Gjerde Sviggum on 10/05/2023.
//

import Foundation

extension GROQuery {
    
    public func order(byField key: GROQKeyRepresentable, direction: Order.Direction) -> Self {
        var orders = (self.underlyingOrder as? [Order]) ?? []
        orders.append(Order(key, direction))
        self.underlyingOrder = orders
        return self
    }
    
}
