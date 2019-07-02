//
//  TagLocationCoordinator.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation


protocol CurrentLocationControllerDelegate: class {
    func viewController(
        _ controller: CurrentLocationViewController,
        didSelectTag location: CLLocation,
        at placemark: CLPlacemark
    )
}


final class TagLocationCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    private let stateController: StateController
    
    
    init(
        navController: UINavigationController = UINavigationController(),
        stateController: StateController
    ) {
        self.navController = navController
        self.stateController = stateController
        
        start()
    }

    
    func start() {
        let currentLocationVC = CurrentLocationViewController.instantiateFromStoryboard(
            named: R.storyboard.tagLocation.name
        )
        
        currentLocationVC.delegate = self
        currentLocationVC.locationManager = stateController.locationManager
        currentLocationVC.tabBarItem = UITabBarItem(title: "Tag", image: UIImage(systemName: "tag.fill"), tag: 0)
        
        navController.setViewControllers([currentLocationVC], animated: true)
    }
}


// MARK: - CurrentLocationControllerDelegate

extension TagLocationCoordinator: CurrentLocationControllerDelegate {
    
    func viewController(
        _ controller: CurrentLocationViewController,
        didSelectTag location: CLLocation,
        at placemark: CLPlacemark
    ) {
        let locationDetailsVC = LocationDetailsViewController.instantiateFromStoryboard(
            named: R.storyboard.tagLocation.name
        )
        
        locationDetailsVC.location = location
        locationDetailsVC.placemark = placemark
        
        navController.pushViewController(locationDetailsVC, animated: true)
    }
    
    
}
