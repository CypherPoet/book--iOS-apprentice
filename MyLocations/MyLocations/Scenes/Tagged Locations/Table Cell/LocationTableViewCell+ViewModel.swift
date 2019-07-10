//
//  LocationTableViewCell+ViewModel.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/10/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation
import CoreLocation


extension LocationTableViewCell {
    
    struct ViewModel {
        var location: Location
    }
}


// MARK: - Computeds

extension LocationTableViewCell.ViewModel {
    
    var nameText: String { location.placemark?.name ?? "(Unknown Name)" }
    
    var addressText: String {
        if
            let placemark = location.placemark,
            let localityLine = placemark.formattedLocalityLine
        {
            return localityLine
        } else {
            let latitudeString = location.latitude.coordinateFormat
            let longitudeString = location.longitude.coordinateFormat
            
            return "Lat: \(latitudeString), Long: \(longitudeString)"
        }
    }
}
