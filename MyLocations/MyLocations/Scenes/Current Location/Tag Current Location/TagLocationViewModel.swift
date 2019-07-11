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
    var latitude: Double
    var longitude: Double
    var placemark: CLPlacemark?
    var category: Location.Category?
    var locationDescription: String
    var dateRecorded: Date
    
//    var selectedPhoto: UIImage?
}


// MARK: - Computeds

extension TagLocationViewModel {
    
    var latitudeText: String { latitude.coordinateFormat }
    var longitudeText: String { longitude.coordinateFormat }
    var dateText: String { dateRecorded.locationCaptureFormat }
    

    var categoryLabelText: String {
        category?.displayValue ?? "Select A Category"
    }

    
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
