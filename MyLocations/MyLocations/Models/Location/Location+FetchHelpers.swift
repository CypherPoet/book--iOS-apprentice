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
    
    static var fetchRequestByDateAsc: NSFetchRequest<Location> {
        let request = Location.makeFetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Location.dateRecorded, ascending: true)
        ]
        
        return request
    }
}
