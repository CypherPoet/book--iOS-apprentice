//
//  CustomAnnotationViewFactory.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/13/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation
import MapKit


enum CustomAnnotationViewFactory {
    static let reuseIdentifier = "Location"
    
    static func makePinView(for annotation: MKAnnotation) -> MKPinAnnotationView {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        pinView.isEnabled = true
        pinView.canShowCallout = true
        pinView.animatesDrop = false
        pinView.pinTintColor = .systemPurple
        
        pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return pinView
    }
}
