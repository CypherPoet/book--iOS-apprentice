//
//  StateController.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/28/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData


final class StateController {
    let managedObjectContext: NSManagedObjectContext
    lazy var locationManager = CLLocationManager()
    
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
}
