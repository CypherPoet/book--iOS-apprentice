//
//  UIViewController+ShowLocationServicesDeniedAlert.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/28/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func showLocationServicesDeniedAlert() {
        display(
            alertMessage: "Please enable location services for this app in Settings.",
            titled: "Location Services Disabled",
            confirmButtonTitle: "👌 OK"
        )
    }
}
