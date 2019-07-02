//
//  LocationErrorMessage.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/1/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


enum LocationDetectionError {
    case timedOut
    case locationUnknown
    case servicesDisabled
    case misc
    case custom(message: String)
}


extension LocationDetectionError {
    var message: String {
        switch self {
        case .timedOut:
            return "Location Fetch Timed Out"
        case .locationUnknown:
            return "Unable to Determine Location"
        case .servicesDisabled:
            return "Location Services Disabled"
        case .custom(let message):
            return message
        case .misc:
            return "Error Getting Location"
        }
    }
}
