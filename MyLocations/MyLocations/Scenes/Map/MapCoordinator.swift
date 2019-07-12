//
//  MapCoordinator.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/12/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


final class MapCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    private let stateController: StateController
    private let tabBarIndex: Int

    
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
    
extension MapCoordinator {
        
    func start() {
        let mapVC = MapViewerViewController.instantiateFromStoryboard(
            named: R.storyboard.map.name
        )
        
        
        mapVC.title = "Map"
        mapVC.tabBarItem = .init(title: "Map", image: UIImage(systemName: "map.fill"), tag: tabBarIndex)
        mapVC.modelController = MapViewerModelController(
            managedObjectContext: stateController.managedObjectContext
        )
        
        navController.setViewControllers([mapVC], animated: true)
    }
}
