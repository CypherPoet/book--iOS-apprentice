//
//  TagLocationCoordinator.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation


final class CurrentLocationCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    private let stateController: StateController
    private let tabBarIndex: Int
    
    
    private var editTaggedLocationCoordinator: EditTaggedLocationCoordinator?

    
    init(
        navController: UINavigationController = UINavigationController(),
        stateController: StateController,
        tabBarIndex: Int
    ) {
        self.navController = navController
        self.stateController = stateController
        self.tabBarIndex = tabBarIndex
        
        Appearance.apply(to: navController.navigationBar)
        start()
    }
}


// MARK: Navigation

extension CurrentLocationCoordinator {
    
    func start() {
        let currentLocationVC = CurrentLocationViewController.instantiateFromStoryboard(
            named: R.storyboard.currentLocation.name
        )
        
        currentLocationVC.delegate = self
        currentLocationVC.locationManager = stateController.locationManager
        currentLocationVC.tabBarItem = UITabBarItem(
            title: "Tag",
            image: R.image.target(),
            tag: tabBarIndex
        )
        
        navController.navigationBar.prefersLargeTitles = false
        navController.navigationBar.isHidden = true
        navController.setViewControllers([currentLocationVC], animated: true)
    }
}


// MARK: - CurrentLocationControllerDelegate

extension CurrentLocationCoordinator: CurrentLocationViewControllerDelegate {
    
    func viewController(
        _ controller: CurrentLocationViewController,
        didSelectTag location: CLLocation,
        at placemark: CLPlacemark?
    ) {
        let newLocationObject = Location(context: stateController.managedObjectContext)
        
        newLocationObject.latitude = location.coordinate.latitude
        newLocationObject.longitude = location.coordinate.longitude
        newLocationObject.placemark = placemark
        newLocationObject.locationDescription = ""
        newLocationObject.dateRecorded = Date()
        
        
        editTaggedLocationCoordinator = EditTaggedLocationCoordinator(
            navController: navController,
            stateController: stateController,
            delegate: self,
            locationToEdit: newLocationObject
        )
        editTaggedLocationCoordinator?.start()
    }
}


// MARK: - EditTaggedLocationCoordinatorDelegate

extension CurrentLocationCoordinator: EditTaggedLocationCoordinatorDelegate {
    
    func coordinatorDidCancel(_ coordinator: EditTaggedLocationCoordinator) {
        editTaggedLocationCoordinator = nil
    }
    
    func coordinatorDidFinishEditingLocation(_ coordinator: EditTaggedLocationCoordinator) {
        editTaggedLocationCoordinator = nil
    }
}

