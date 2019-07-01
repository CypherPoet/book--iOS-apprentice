//
//  CurrentLocationView+ViewModel.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/28/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


extension CurrentLocationView {
    
    struct ViewModel {
        var currentLatitude: Double?
        var currentLongitude: Double?
        var locationErrorMessage: String?
        var isFetchingLocation: Bool = false
        
        var stopFetchLocationButtonTitle = "Stop"
        var fetchLocationButtonTitle = "Get My Location"

        var startFetchingLocationMessage = "Tap \"Get My Location\" to Start"
        var locationFetchInProgressMessage = "Searching for New Cooridinates..."

        var decodedAddress: String?
        var decodedAddressErrorMessage: String?
        var addressDecodingInProgressMessage = "Searching for Address..."
        var isDecodingAddress: Bool = false
    }
}


// MARK: - Computeds

extension CurrentLocationView.ViewModel {
    
    var latitudeText: String { currentLatitude?.coordinateFormat ?? "_ _ _ _" }
    var longitudeText: String { currentLongitude?.coordinateFormat ?? "_ _ _ _" }
    

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
            return decodedAddressErrorMessage ?? decodedAddress
        }
    }
    
    
    var locationFetchButtonText: String {
        return isFetchingLocation ? stopFetchLocationButtonTitle : fetchLocationButtonTitle
    }
}
