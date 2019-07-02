//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation


class LocationDetailsViewController: UITableViewController, Storyboarded {
    var location: CLLocation!
    var placemark: CLPlacemark!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(location != nil, "No location was set")
        assert(placemark != nil, "No placemark was set")
    }
}
