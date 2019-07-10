//
//  TagLocationModelController.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/9/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData


final class TagLocationModelController {
    private let stateController: StateController
    
    typealias Changes = (
        latitude: Double,
        longitude: Double,
        category: Location.Category,
        dateRecorded: Date,
        placemark: CLPlacemark?,
        locationDescription: String
    )
    
    
    init(stateController: StateController) {
        self.stateController = stateController
    }
}


extension TagLocationModelController {

    private var managedObjectContext: NSManagedObjectContext {
        stateController.managedObjectContext
    }
}


extension TagLocationModelController {
    
    func saveLocation(
        with changes: Changes,
        then completionHandler: ((Result<Void, Error>) -> Void)
    ) {
        let location = Location(context: managedObjectContext)

        location.latitude = changes.latitude
        location.longitude = changes.latitude
        location.category = changes.category
        location.dateRecorded = changes.dateRecorded
        location.placemark = changes.placemark
        location.locationDescription = changes.locationDescription

        do {
            try managedObjectContext.save()
            completionHandler(.success(()))
        } catch {
            completionHandler(.failure(error))
        }
        
    }
}
