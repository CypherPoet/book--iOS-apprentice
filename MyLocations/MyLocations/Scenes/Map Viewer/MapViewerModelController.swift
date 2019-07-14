//
//  MapViewerModelController.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/12/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation
import CoreData


final class MapViewerModelController {
    private let managedObjectContext: NSManagedObjectContext

    private lazy var fetchRequest: NSFetchRequest<Location> = makeFetchRequest()

    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
}



// MARK: - Core Methods

extension MapViewerModelController {
    typealias FetchCompletionHandler = ((Result<[Location], Error>) -> Void)
    
    
    func fetchLocations(
        on queue: DispatchQueue = .global(qos: .userInitiated),
        then completionHandler: @escaping FetchCompletionHandler
    ) {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            do {
                let locations = try self.managedObjectContext.fetch(self.fetchRequest)
                completionHandler(.success(locations))
            } catch {
                self.fatalCoreDataError(error)
            }
        }
    }
}


private extension MapViewerModelController {

    func makeFetchRequest() -> NSFetchRequest<Location> {
        Location.makeFetchRequest()
    }
}


extension MapViewerModelController: CoreDataErrorHandling {}
