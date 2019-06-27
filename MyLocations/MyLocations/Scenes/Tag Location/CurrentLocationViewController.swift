//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation



class CurrentLocationViewController: UIViewController, Storyboarded {
    @IBOutlet var mainView: CurrentLocationView!
    
    private lazy var locationManager = makeLocationManager()
}


// MARK: - Lifecycle

extension CurrentLocationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Current Location"
        mainView.delegate = self
    }
}


// MARK: - CLLocationManagerDelegate

extension CurrentLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}


// MARK: - CurrentLocationViewDelegate

extension CurrentLocationViewController: CurrentLocationViewDelegate {
    
    func viewDidSelectGetLocation(_ view: CurrentLocationView) {
        locationManager.startUpdatingLocation()
    }
}


private extension CurrentLocationViewController {
    
    func makeLocationManager() -> CLLocationManager {
        let locationManager = CLLocationManager()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        return locationManager
    }
}
