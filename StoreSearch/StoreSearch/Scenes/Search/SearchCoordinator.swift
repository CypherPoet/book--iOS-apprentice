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
        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = searchVC
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search the iTunes Store"
        searchController.definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = APIMediaType.allTitles

        searchVC.modelController = SearchModelController()
        searchVC.viewModel = SearchViewModel(searchController: searchController)
        
        searchVC.navigationItem.searchController = searchController
        searchVC.title = "iTunes Store Search"
        
        Appearance.apply(to: searchController.searchBar)
        Appearance.apply(to: navController.navigationBar)
        navController.navigationBar.prefersLargeTitles = true
        
        navController.setViewControllers([searchVC], animated: true)
    }
}
