//
//  CodingUserInfoKey+ManagedObjectContext.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/8/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


public extension CodingUserInfoKey {
    
    /// Helper property to retrieve the Core Data managed object
    /// context from the `userInfo` dictionary of a decoder instance.
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
