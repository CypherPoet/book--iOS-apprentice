//
//  TagLocationViewModel.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation
import CoreLocation

struct TagLocationViewModel {
    var coordinate: CLLocationCoordinate2D
    var placemark: CLPlacemark?
//    var category: Location.Category
    var locationDescription: String
    var date: Date
    
//    var selectedPhoto: UIImage?
}


extension TagLocationViewModel {
    
    var latitudeText: String { coordinate.latitude.coordinateFormat }
    var longitudeText: String { coordinate.longitude.coordinateFormat }
    var dateText: String { date.locationCaptureFormat }
    
    
    var addressText: String {
        guard let placemark = placemark else { return "Unknown Address" }
        
        return [
            placemark.name,
            placemark.formattedMainLine,
            placemark.formattedLocalityLine,
            placemark.country,
        ]
        .compactMap({ $0 })
        .joined(separator: "\n")
    }
}
