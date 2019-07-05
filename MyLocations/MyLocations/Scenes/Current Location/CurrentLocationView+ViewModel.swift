//
//  CurrentLocationView+ViewModel.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/28/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation
import CoreLocation

extension CurrentLocationView {
    
    struct ViewModel {
        var currentLocation: CLLocation?
        var locationErrorMessage: String?
        var isFetchingLocation: Bool = false

        var currentPlacemark: CLPlacemark?
        var isDecodingAddress: Bool = false
        var decodedAddressErrorMessage: String?
        var addressDecodingInProgressMessage = "Searching for Address..."
        
        var stopFetchLocationButtonTitle = "Stop"
        var fetchLocationButtonTitle = "Get My Location"
        
        var startFetchingLocationMessage = "Tap \"Get My Location\" to Start"
        var locationFetchInProgressMessage = "Searching for New Coordinates..."
    }
}


// MARK: - Computeds

extension CurrentLocationView.ViewModel {
    
    var latitudeText: String { currentLocation?.coordinate.latitude.coordinateFormat ?? "_ _ _ _" }
    var longitudeText: String { currentLocation?.coordinate.longitude.coordinateFormat ?? "_ _ _ _" }
    

    var locationReadingHeaderText: String? {
        if isFetchingLocation {
            return locationFetchInProgressMessage
        } else {
            return locationErrorMessage ?? startFetchingLocationMessage
        }
    }
    
    var decodedAddressText: String? {
        if isDecodingAddress {
            return addressDecodingInProgressMessage
        } else {
            return decodedAddressErrorMessage ?? formattedPlacemarkAddress
        }
    }
    
    
    var locationFetchButtonText: String {
        return isFetchingLocation ? stopFetchLocationButtonTitle : fetchLocationButtonTitle
    }
}


// MARK: - Private Helpers

private extension CurrentLocationView.ViewModel {
    
    var formattedPlacemarkAddress: String? {
        [
            currentPlacemark?.name,
            currentPlacemark?.formattedMainLine,
            currentPlacemark?.formattedLocalityLine,
        ]
        .compactMap({ $0 })
        .joined(separator: "\n")
    }
}
