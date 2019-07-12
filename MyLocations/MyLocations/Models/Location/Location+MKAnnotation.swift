//
//  Location+MKAnnotation.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/12/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation
import MapKit


extension Location: MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
    
    public var title: String? { placemark?.name ?? "(Unknown Name)" }
    public var subtitle: String? { locationDescription }
}
