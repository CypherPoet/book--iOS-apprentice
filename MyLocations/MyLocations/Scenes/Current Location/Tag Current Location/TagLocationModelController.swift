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
    private let locationToEdit: Location
    
    
    typealias Changes = (
        latitude: Double,
        longitude: Double,
        category: Location.Category,
        dateRecorded: Date,
        placemark: CLPlacemark?,
        locationDescription: String,
        photoData: Data?
    )
    
    
    init(stateController: StateController, locationToEdit: Location) {
        self.stateController = stateController
        self.locationToEdit = locationToEdit
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
        locationToEdit.latitude = changes.latitude
        locationToEdit.longitude = changes.longitude
        locationToEdit.category = changes.category
        locationToEdit.dateRecorded = changes.dateRecorded
        locationToEdit.placemark = changes.placemark
        locationToEdit.locationDescription = changes.locationDescription
        
        // Don't overwrite the existing photo if there's no new photo data
        if let photoData = changes.photoData {
            locationToEdit.photoData = photoData
        }
        
        do {
            try managedObjectContext.save()
            completionHandler(.success(()))
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    
    func deletePhoto(then completionHandler: ((Result<Void, Error>) -> Void)) {
        locationToEdit.photoData = nil

        do {
            try managedObjectContext.save()
            completionHandler(.success(()))
        } catch {
            completionHandler(.failure(error))
        }
        
    }
}
