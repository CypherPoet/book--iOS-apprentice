//
//  SearchCoordinator.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/22/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


final class SearchCoordinator: NavigationCoordinator {
    var navController: UINavigationController

    
    init(navController: UINavigationController) {
        self.navController = navController
    }
}


// MARK: - Coordinator

extension SearchCoordinator: Coordinator {

    func start() {
        let searchVC = SearchViewController.instantiateFromStoryboard(
            named: R.storyboard.search.name
        )
        
        searchVC.modelController = SearchModelController()
        
        navController.navigationBar.isHidden = true
        navController.setViewControllers([searchVC], animated: true)
    }
}
