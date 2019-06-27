//
//  TagLocationCoordinator.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


final class TagLocationCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    
    
    // TODO: Should the navController be optional here?
    init(navController: UINavigationController = UINavigationController()) {
        self.navController = navController
        
        start()
    }

    
    func start() {
        let currentLocationVC = CurrentLocationViewController.instantiateFromStoryboard(
            named: R.storyboard.tagLocation.name
        )
        
        navController.setViewControllers([currentLocationVC], animated: true)
    }
    
}
