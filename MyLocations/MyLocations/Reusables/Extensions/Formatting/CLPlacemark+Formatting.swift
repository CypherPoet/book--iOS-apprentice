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
    
    var multilineFormattedAddress: String? {
        let line1 = name ?? ""

        
        var line2 = ""
        
        if let subThoroughfare = subThoroughfare {
            line2 += "\(subThoroughfare) "
        }
        
        if let thoroughfare = thoroughfare {
            line2 += thoroughfare
        }
        
        
        var line3 = ""
        
        if let locality = locality {
            line3 += "\(locality)"
        }
        
        if let administrativeArea = administrativeArea {
            line3 += ", \(administrativeArea)"
        }
        
        if let postalCode = postalCode {
            line3 += " \(postalCode)"
        }
        
        
        return [
            line1,
            line2,
            line3,
        ]
        .filter { !$0.isEmpty }
        .joined(separator: "\n")
    }
}
