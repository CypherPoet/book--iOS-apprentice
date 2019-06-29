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
        var currentAddress: String?
        var isFetchingLocation: Bool = false
        var locationErrorMessage: String?
    }
}


// MARK: - Computeds

extension CurrentLocationView.ViewModel {
    
    var latitudeText: String { currentLatitude?.coordinateFormat ?? "_ _ _ _" }
    var longitudeText: String { currentLongitude?.coordinateFormat ?? "_ _ _ _" }
    
    var currentAddressText: String {
        ""
    }
    
    
    var locationStatusMessage: String? {
        guard locationErrorMessage == nil else {
            return locationErrorMessage
        }
        
        if isFetchingLocation {
            return "Searching..."
        } else {
            return "Tap \"Get My Location\" to start."
        }
    }
}
