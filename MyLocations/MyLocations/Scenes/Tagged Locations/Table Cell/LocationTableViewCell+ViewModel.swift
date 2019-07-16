//
//  LocationTableViewCell+ViewModel.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/10/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation


extension LocationTableViewCell {
    
    struct ViewModel {
        var latitude: Double
        var longitude: Double
        var placemark: CLPlacemark?
        var locationPhoto: UIImage?
        var photoImageWidth = 52
        var photoImageHeight = 52
    }
}


// MARK: - Computeds

extension LocationTableViewCell.ViewModel {
    
    var nameText: String { placemark?.name ?? "(Unknown Name)" }
    
    var addressText: String {
        if
            let placemark = placemark,
            let localityLine = placemark.formattedLocalityLine
        {
            return localityLine
        } else {
            let latitudeString = latitude.coordinateFormat
            let longitudeString = longitude.coordinateFormat
            
            return "Lat: \(latitudeString), Long: \(longitudeString)"
        }
    }
    
    
    var photoImage: UIImage? {
        guard let originalImage = locationPhoto else {
            return Location.photoPlaceholder
        }
        
        return originalImage.resized(
            withBounds: CGSize(width: photoImageWidth, height: photoImageHeight)
        )
    }
}
