//
//  Date+Formatting.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation

extension Date {
    
    var locationCaptureFormat: String {
        DateFormatter.locationDetailsDateFormatter.string(from: self)
    }
}
