//
//  Double+Formatting.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/28/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation

extension Double {
    
    var coordinateFormat: String {
        String(format: "%.8f", self)
    }
}
