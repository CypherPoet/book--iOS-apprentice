//
//  Location+CoreDataProperties.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/8/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation


extension Location {
    
    @nonobjc public class func makeFetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }
    
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var dateRecorded: Date
    @NSManaged public var locationDescription: String
    @NSManaged public var placemark: CLPlacemark?
    
    
    @NSManaged private var categoryValue: Int32
    
    var category: Location.Category {
        get { return Location.Category(rawValue: self.categoryValue)! }
        
        set {
            self.categoryValue = newValue.rawValue
        }
    }
}
