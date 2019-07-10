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
    func coordinatorDidFinishTaggingLocation(_ coordinator: TagLocationCoordinator)
}

protocol TagLocationViewControllerDelegate: class {
    func viewControllerDidCancel(_ controller: TagLocationViewController)
    func viewControllerDidSaveLocation(_ controller: TagLocationViewController)
    func viewControllerDidSelectChooseCategory(_ controller: TagLocationViewController)
}


protocol CategoryListViewControllerDelegate: class {
    func viewControllerDidCancel(_ controller: CategoryListViewController)
    func viewController(_ controller: CategoryListViewController, didSelect category: Location.Category)
}



final class TagLocationCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    private let stateController: StateController
    private weak var delegate: TagLocationCoordinatorDelegate?
    private let coordinate: CLLocationCoordinate2D
    private let placemark: CLPlacemark?
    
    
    private var tagLocationViewController: TagLocationViewController!
    
    
    init(
        navController: UINavigationController,
        stateController: StateController,
        delegate: TagLocationCoordinatorDelegate?,
        coordinate: CLLocationCoordinate2D,
        placemark: CLPlacemark?
    ) {
        self.navController = navController
        self.stateController = stateController
        self.delegate = delegate
        self.coordinate = coordinate
        self.placemark = placemark
    }
    
    
    func start() {
        tagLocationViewController = TagLocationViewController.instantiateFromStoryboard(
            named: R.storyboard.tagLocation.name
        )
        
        tagLocationViewController.delegate = self
        tagLocationViewController.title = "Tag Location"
        tagLocationViewController.modelController = TagLocationModelController(stateController: stateController)
        
        tagLocationViewController.viewModel = .init(
            coordinate: coordinate,
            placemark: placemark,
            locationDescription: "",
            dateRecorded: Date()
        )
        
        navController.navigationBar.isHidden = false
        navController.pushViewController(tagLocationViewController, animated: true)
    }
}


// MARK: - TagLocationViewControllerDelegate

extension TagLocationCoordinator: TagLocationViewControllerDelegate {
    
    func viewControllerDidSaveLocation(_ controller: TagLocationViewController) {
        delegate?.coordinatorDidFinishTaggingLocation(self)
    }
    
    
    func viewControllerDidSelectChooseCategory(_ controller: TagLocationViewController) {
        let categoryListVC = CategoryListViewController.instantiateFromStoryboard(
            named: R.storyboard.tagLocation.name
        )
        
        categoryListVC.delegate = self
        categoryListVC.currentCategory = tagLocationViewController.viewModel.category
        categoryListVC.categories = Location.Category.allCases
        categoryListVC.title = "Select A Category"
        
        navController.pushViewController(categoryListVC, animated: true)
    }
    
    
    func viewControllerDidCancel(_ controller: TagLocationViewController) {
        delegate?.coordinatorDidCancel(self)
    }
}


// MARK: - CategoryListViewControllerDelegate

extension TagLocationCoordinator: CategoryListViewControllerDelegate {
    
    func viewControllerDidCancel(_ controller: CategoryListViewController) {
        navController.popViewController(animated: true)
    }
    
    
    func viewController(
        _ controller: CategoryListViewController,
        didSelect category: Location.Category
    ) {
        navController.popViewController(animated: true)
        tagLocationViewController.viewModel.category = category
    }
}
