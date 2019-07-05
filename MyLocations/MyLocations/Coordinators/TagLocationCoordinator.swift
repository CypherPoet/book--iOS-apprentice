//
//  LocationDetailsCoordinator.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/4/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation

// TODO: Place protocols in separate files

protocol TagLocationCoordinatorDelegate: class {
    func coordinatorDidCancel(_ coordinator: TagLocationCoordinator)
}

protocol TagLocationViewControllerDelegate: class {
    func viewControllerDidCancel(_ controller: TagLocationViewController)
//    func viewController(_ controller: LocationDetailsViewController, didSubmit location: Location)
}

protocol LocationCategoryViewControllerDelegate: class {
    func viewControllerDidCancel(_ controller: LocationCategoryViewControllerDelegate)
}



final class TagLocationCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    private weak var delegate: TagLocationCoordinatorDelegate?
    private let coordinate: CLLocationCoordinate2D
    private let placemark: CLPlacemark?
    
    init(
        navController: UINavigationController,
        delegate: TagLocationCoordinatorDelegate?,
        coordinate: CLLocationCoordinate2D,
        placemark: CLPlacemark?
    ) {
        self.navController = navController
        self.delegate = delegate
        self.coordinate = coordinate
        self.placemark = placemark
    }
    
    
    func start() {
        let tagLocationVC = TagLocationViewController.instantiateFromStoryboard(
            named: R.storyboard.tagLocation.name
        )
        
        tagLocationVC.delegate = self
        tagLocationVC.title = "Tag Location"
        
        tagLocationVC.viewModel = .init(
            coordinate: coordinate,
            placemark: placemark,
            locationDescription: "",
            date: Date()
        )
        
        navController.navigationBar.isHidden = false
        navController.pushViewController(tagLocationVC, animated: true)
    }
}


// MARK: - LocationDetailsViewControllerDelegate

extension TagLocationCoordinator: TagLocationViewControllerDelegate {
    
    func viewControllerDidCancel(_ controller: TagLocationViewController) {
        delegate?.coordinatorDidCancel(self)
    }
}


extension TagLocationCoordinator: LocationCategoryViewControllerDelegate {
    
    func viewControllerDidCancel(_ controller: LocationCategoryViewControllerDelegate) {
        navController.popViewController(animated: true)
    }
    
    
}

