//
//  CLPlacemark+Formatting.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/30/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation

extension CLPlacemark {
    
    var formattedMainLine: String? {
        [subThoroughfare, thoroughfare]
            .compactMap({ $0 })
            .joined(separator: ", ")
    }
    
    
    var formattedLocalityLine: String? {
        [
            locality,
            administrativeArea,
            postalCode,
        ]
        .compactMap({ $0 }).joined(separator: ", ")
    }
}
