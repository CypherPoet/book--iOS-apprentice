//
//  MKCoordinateRegion+BoundingAnnotations.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/12/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation
import MapKit

extension MKCoordinateSpan {
    typealias BoundingMetrics = (boundingSpan: MKCoordinateSpan, center: CLLocationCoordinate2D)
    
    
    static func boundingMetrics(for annotations: [MKAnnotation]) -> BoundingMetrics {
        guard annotations.count > 1 else {
            preconditionFailure("Multiple annotations are needed to compute a coordinate span")
        }
        
        typealias Bounds = (topLeft: CLLocationCoordinate2D, bottomRight: CLLocationCoordinate2D)
        
        let initialBounds: Bounds = (
            topLeft: CLLocationCoordinate2D(latitude: -90, longitude: 180),
            bottomRight: CLLocationCoordinate2D(latitude: 90, longitude: -180)
        )
        
        
        let (boundedTopLeft, boundedBottomRight) = annotations
            .reduce(initialBounds, { (currentBounds: Bounds, currentAnnotation) -> Bounds in
                let newMinLatitude = min(currentBounds.bottomRight.latitude, currentAnnotation.coordinate.latitude)
                let newMaxLatitude = max(currentBounds.topLeft.latitude, currentAnnotation.coordinate.latitude)
                
                let newMinLongitude = min(currentBounds.topLeft.longitude, currentAnnotation.coordinate.longitude)
                let newMaxLongitude = max(currentBounds.bottomRight.longitude, currentAnnotation.coordinate.longitude)
                
                let newTopLeft = CLLocationCoordinate2D(latitude: newMaxLatitude, longitude: newMinLongitude)
                let newBottomRight = CLLocationCoordinate2D(latitude: newMinLatitude, longitude: newMaxLongitude)
                
                return (topLeft: newTopLeft, bottomRight: newBottomRight)
            }
        )
        
        
        let centerLatitude = boundedBottomRight.latitude - ((boundedBottomRight.latitude - boundedTopLeft.latitude) / 2.0)
        let centerLongitude = boundedBottomRight.longitude - ((boundedBottomRight.longitude - boundedTopLeft.longitude) / 2.0)

        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        
        let boundingSpan = MKCoordinateSpan(
            latitudeDelta: abs(boundedTopLeft.latitude - boundedBottomRight.latitude),
            longitudeDelta: abs(boundedTopLeft.longitude - boundedBottomRight.longitude)
        )
        
        return (boundingSpan, center)
    }
}
