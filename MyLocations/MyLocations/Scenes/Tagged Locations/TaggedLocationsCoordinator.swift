//
//  TaggedLocationsCoordinator.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/9/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


final class TaggedLocationsCoordinator: NavigationCoordinator {
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

        start()
    }
}


// MARK: Navigation

extension TaggedLocationsCoordinator {
    
    func start() {
        let taggedLocationsListVC = TaggedLocationsListViewController.instantiateFromStoryboard(
            named: R.storyboard.taggedLocations.name
        )

        taggedLocationsListVC.tabBarItem = UITabBarItem(
            title: "Locations",
            image: UIImage(systemName: "star.circle"),
            tag: tabBarIndex
        )
        taggedLocationsListVC.modelController = .init(
            managedObjectContext: stateController.managedObjectContext
        )
        taggedLocationsListVC.title = "Tagged Locations"
        taggedLocationsListVC.delegate = self
        
        navController.navigationBar.prefersLargeTitles = true
        navController.setViewControllers([taggedLocationsListVC], animated: true)
    }
}


// MARK: - TaggedLocationsListViewControllerDelegate

extension TaggedLocationsCoordinator: TaggedLocationsListViewControllerDelegate {
    
    func viewController(
        _ viewController: TaggedLocationsListViewController,
        didSelectEditingFor location: Location
    ) {
        editTaggedLocationCoordinator = EditTaggedLocationCoordinator(
            navController: navController,
            stateController: stateController,
            delegate: self,
            locationToEdit: location
        )
        editTaggedLocationCoordinator?.start()
    }
}


// MARK: - EditTaggedLocationCoordinatorDelegate

extension TaggedLocationsCoordinator: EditTaggedLocationCoordinatorDelegate {
    
    func coordinatorDidCancel(_ coordinator: EditTaggedLocationCoordinator) {
        editTaggedLocationCoordinator = nil
    }
    
    
    func coordinatorDidFinishEditingLocation(_ coordinator: EditTaggedLocationCoordinator) {
        editTaggedLocationCoordinator = nil
    }
}
