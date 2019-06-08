//
//  Identifiable.swift
//  Checklists
//
//  Created by Brian Sipple on 6/8/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation

/// A type that can be compared for identify equality
protocol Identifiable {
    
    /// A type of unique identifier that can be compared for equality
    associatedtype ID: Hashable
    
    /// A unique identifier that can be compared for equality
    var id: Self.ID { get }
    
    /// A type of value identified by `id`
    associatedtype IdentifiedValue = Self
    
    /// The value identified by `id`
    ///
    /// By default, this returns `self`
    var identifiedValue: Self.IdentifiedValue { get }
}


extension Identifiable where Self == Self.IdentifiedValue {
    var identifiedValue: Self {
        return self
    }
}


extension Identifiable where Self: AnyObject {
    var id: ObjectIdentifier {
        return ObjectIdentifier(self)
    }
}
