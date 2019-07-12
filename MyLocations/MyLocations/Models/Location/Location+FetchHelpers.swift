//
//  Location+FetchHelpers.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/10/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation
import CoreData


extension Location {

    static let defaultSortDescriptors = [
        NSSortDescriptor(keyPath: \Location.categoryValue, ascending: true),
        NSSortDescriptor(keyPath: \Location.dateRecorded, ascending: true),
    ]
    
    
    static var defaultFetchRequest: NSFetchRequest<Location> {
        let request = Location.makeFetchRequest()
        
        request.sortDescriptors = defaultSortDescriptors

        return request
    }
    
    
    enum FetchRequest {
        case byCategoryByDateAsc
    }
}


extension Location.FetchRequest {
    
    var request: NSFetchRequest<Location> {
        let request = Location.makeFetchRequest()
        
        switch self {
        case .byCategoryByDateAsc:
            request.sortDescriptors = Location.defaultSortDescriptors
        }
        
        return request
    }
}


extension Location {
    static let cacheName = "Locations"
}
