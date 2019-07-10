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
    

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
}


// MARK: - Core Methods

extension TaggedLocationsModelController {
    typealias FetchCompletionHandler = ((Result<[Location], Error>) -> Void)
    
    func fetchLocations(then completionHandler: FetchCompletionHandler) {
        let request = Location.fetchRequestByDateAsc
        
        do {
            let locations = try managedObjectContext.fetch(request)
            completionHandler(.success(locations))
        } catch {
            fatalCoreDataError(error)
        }
    }
    
}


extension TaggedLocationsModelController: CoreDataContextHandling {}
