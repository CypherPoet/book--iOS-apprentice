//
//  EditTaggedLocationCoordinator.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/10/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//


import UIKit
import CoreLocation


protocol EditTaggedLocationCoordinatorDelegate: class {
    func coordinatorDidCancel(_ coordinator: EditTaggedLocationCoordinator)
    func coordinatorDidFinishEditingLocation(_ coordinator: EditTaggedLocationCoordinator)
}


final class EditTaggedLocationCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    private let stateController: StateController
    private weak var delegate: EditTaggedLocationCoordinatorDelegate?
    private let locationToEdit: Location
    
    private var tagLocationViewController: TagLocationViewController!
    
    
    init(
        navController: UINavigationController,
        stateController: StateController,
        delegate: EditTaggedLocationCoordinatorDelegate?,
        locationToEdit: Location
    ) {
        self.navController = navController
        self.stateController = stateController
        self.delegate = delegate
        self.locationToEdit = locationToEdit
    }
    
    
    func start() {
        tagLocationViewController = TagLocationViewController.instantiateFromStoryboard(
            named: R.storyboard.tagLocation.name
        )
        
        tagLocationViewController.delegate = self
        tagLocationViewController.title = "Edit Location"
        
        tagLocationViewController.modelController = TagLocationModelController(
            stateController: stateController,
            locationToEdit: locationToEdit
        )
        
        tagLocationViewController.viewModel = .init(
            latitude: locationToEdit.latitude,
            longitude: locationToEdit.longitude,
            placemark: locationToEdit.placemark,
            category: locationToEdit.category,
            locationDescription: locationToEdit.locationDescription,
            dateRecorded: locationToEdit.dateRecorded
        )
        
        navController.pushViewController(tagLocationViewController, animated: true)
    }
}


// MARK: - TagLocationViewControllerDelegate

extension EditTaggedLocationCoordinator: TagLocationViewControllerDelegate {
    
    func viewControllerDidSaveLocation(_ controller: TagLocationViewController) {
        delegate?.coordinatorDidFinishEditingLocation(self)
    }
    
    
    func viewControllerDidCancel(_ controller: TagLocationViewController) {
        delegate?.coordinatorDidCancel(self)
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
}


// MARK: - CategoryListViewControllerDelegate

extension EditTaggedLocationCoordinator: CategoryListViewControllerDelegate {
    
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
