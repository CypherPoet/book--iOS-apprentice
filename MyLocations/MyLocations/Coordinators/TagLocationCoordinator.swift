//
//  TagLocationCoordinator.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation


// TODO: Place protocols in separate files

protocol CurrentLocationControllerDelegate: class {
    func viewController(
        _ controller: CurrentLocationViewController,
        didSelectTag location: CLLocation,
        at placemark: CLPlacemark?
    )
}

protocol LocationDetailsViewControllerDelegate: class {
    func viewControllerDidCancel(_ controller: LocationDetailsViewController)
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
        
        navController.navigationBar.prefersLargeTitles = false
        navController.navigationBar.isHidden = true
        navController.setViewControllers([currentLocationVC], animated: true)
    }
}


// MARK: - CurrentLocationControllerDelegate

extension TagLocationCoordinator: CurrentLocationControllerDelegate {
    
    func viewController(
        _ controller: CurrentLocationViewController,
        didSelectTag location: CLLocation,
        at placemark: CLPlacemark?
    ) {
        let locationDetailsVC = LocationDetailsViewController.instantiateFromStoryboard(
            named: R.storyboard.tagLocation.name
        )
        
        locationDetailsVC.delegate = self
        locationDetailsVC.title = "Tag Location"
        
        locationDetailsVC.viewModel = .init(
            coordinate: location.coordinate,
            placemark: placemark,
            description: "",
            date: Date()
        )

        navController.navigationBar.isHidden = false
        navController.pushViewController(locationDetailsVC, animated: true)
    }
}



// MARK: - LocationDetailsViewControllerDelegate

extension TagLocationCoordinator: LocationDetailsViewControllerDelegate {
    
    func viewControllerDidCancel(_ controller: LocationDetailsViewController) {
        navController.popViewController(animated: true)
        navController.navigationBar.isHidden = true
    }
    
}
