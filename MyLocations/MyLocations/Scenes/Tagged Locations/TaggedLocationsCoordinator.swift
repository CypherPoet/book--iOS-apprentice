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

    
    init(navController: UINavigationController = UINavigationController()) {
        self.navController = navController
        
        start()
    }
    
    
    func start() {
        let taggedLocationsListVC = TaggedLocationsListViewController.instantiateFromStoryboard(
            named: R.storyboard.taggedLocations.name
        )
        
        taggedLocationsListVC.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(systemName: "star.circle"), tag: 1)
        
        navController.navigationBar.prefersLargeTitles = true
        navController.setViewControllers([taggedLocationsListVC], animated: true)
    }
}
