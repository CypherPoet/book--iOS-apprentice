//
//  MapViewerCoordinator.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/12/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import MapKit


final class MapViewerCoordinator: NavigationCoordinator {
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
        
        navController.navigationBar.prefersLargeTitles = false
        
        start()
    }
}


// MARK: Navigation
    
extension MapViewerCoordinator {
        
    func start() {
        let mapViewerVC = MapViewerViewController.instantiateFromStoryboard(
            named: R.storyboard.map.name
        )
        
        mapViewerVC.title = "Map"
        mapViewerVC.tabBarItem = .init(title: "Map", image: UIImage(systemName: "map.fill"), tag: tabBarIndex)
        mapViewerVC.delegate = self
        
        mapViewerVC.managedObjectContext = stateController.managedObjectContext
        mapViewerVC.modelController = MapViewerModelController(
            managedObjectContext: stateController.managedObjectContext
        )
        
        navController.setViewControllers([mapViewerVC], animated: true)
    }
}



// MARK: MapViewerViewControllerDelegate

extension MapViewerCoordinator: MapViewerViewControllerDelegate {
    
    func controller(
        _ controller: MapViewerViewController,
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

extension MapViewerCoordinator: EditTaggedLocationCoordinatorDelegate {
    
    func coordinatorDidCancel(_ coordinator: EditTaggedLocationCoordinator) {
        editTaggedLocationCoordinator = nil
    }
    
    func coordinatorDidFinishEditingLocation(_ coordinator: EditTaggedLocationCoordinator) {
        editTaggedLocationCoordinator = nil
    }
}
