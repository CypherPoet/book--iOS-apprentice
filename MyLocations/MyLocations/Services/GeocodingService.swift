//
//  GeocodingService.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/30/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation

final class GeocodingService {
    enum GeocodingServiceError: Error {
        case coreLocationError(Error)
        case noPlacemarks
    }
    
    typealias ReverseGeocodeHandler = ((Result<CLPlacemark, GeocodingServiceError>) -> Void)
    
    
    func reverseGeocode(
        _ location: CLLocation,
        on queue: DispatchQueue = .global(qos: .utility),
        then completionHandler: @escaping ReverseGeocodeHandler
    ) {
        queue.async {
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
                guard error == nil else {
                    return completionHandler(.failure(.coreLocationError(error!)))
                }
             
                guard let placemark = placemarks?.first else {
                    return completionHandler(.failure(.noPlacemarks))
                }
                
                completionHandler(.success(placemark))
            }
        }
    }
}
