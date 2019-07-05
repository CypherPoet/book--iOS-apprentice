//
//  Location+Category.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/4/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation

extension Location {
    
    enum Category: CaseIterable {
        case none
        case appleStore
        case cafe
        case gym
        case house
        case landmark
        case library
        case market
        case museum
        case park
        case skatepark
        case streetVendor
        case studio
    }
}


extension Location.Category {
    
    var displayValue: String {
        switch self {
        case .none:
            return "No Category"
        case .appleStore:
            return "Apple Store"
        case .cafe:
            return "Cafe"
        case .gym:
            return "Gym"
        case .house:
            return "House"
        case .landmark:
            return "Landmark"
        case .library:
            return "Library"
        case .market:
            return "Market"
        case .museum:
            return "Museum"
        case .park:
            return "Park"
        case .skatepark:
            return "Skatepark"
        case .streetVendor:
            return "Street Vendor"
        case .studio:
            return "Studio"
        }
    }
    
}
