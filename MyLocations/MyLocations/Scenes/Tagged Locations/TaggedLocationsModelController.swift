//
//  TaggedLocationsModelController.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/10/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation
import CoreData


final class TaggedLocationsModelController {
    private let managedObjectContext: NSManagedObjectContext
    
    lazy var locationsFetchRequest: NSFetchRequest<Location> = {
        let request = Location.FetchRequest.byCategoryByDateAsc.request
        
        request.fetchBatchSize = 20
        
        return request
    }()

    
    lazy var fetchedResultsController = NSFetchedResultsController(
        fetchRequest: locationsFetchRequest,
        managedObjectContext: managedObjectContext,
        sectionNameKeyPath: "categoryValue",
//        cacheName: Location.cacheName
        cacheName: nil
    )


    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
}


// MARK: - Core Methods

extension TaggedLocationsModelController {

    func fetchLocations() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    
    func delete(_ location: Location) {
        managedObjectContext.delete(location)
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalCoreDataError(error)
        }
    }
}


extension TaggedLocationsModelController: CoreDataErrorHandling {}
