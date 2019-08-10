//
//  Localizable.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/9/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


protocol Localizable {
    var tableName: String { get }
    var localized: String { get }
}


extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    
    var localized: String {
        rawValue.localized(tableName: tableName)
    }
}
