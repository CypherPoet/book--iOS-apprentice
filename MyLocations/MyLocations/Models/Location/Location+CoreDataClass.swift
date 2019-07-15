//
//  Location+CoreDataClass.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/8/19.
//
//

import UIKit
import CoreData

@objc(Location)
public class Location: NSManagedObject {
    
    var photoImage: UIImage? {
        if let photoData = photoData {
            return UIImage(data: photoData)
        } else {
            return nil
        }
    }
}
