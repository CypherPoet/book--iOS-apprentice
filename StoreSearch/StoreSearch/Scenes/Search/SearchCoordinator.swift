//
//  SearchCoordinator.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/22/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


final class SearchCoordinator: NSObject, NavigationCoordinator {
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

        searchVC.delegate = self
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


// MARK: - SearchViewControllerDelegate

extension SearchCoordinator: SearchViewControllerDelegate {
    
    func viewController(
        _ controller: SearchViewController,
        didSelectDetailsFor searchResult: SearchResult
    ) {
        let searchResultDetailsVC = SearchResultDetailsViewController.instantiateFromStoryboard(
            named: R.storyboard.search.name
        )
        
        searchResultDetailsVC.viewModel = SearchResultDetailsViewController.ViewModel(
            artistName: searchResult.artistName,
            contentType: searchResult.contentType,
            contentGenre: searchResult.primaryGenre,
            price: searchResult.price,
            storeURL: searchResult.storeURL,
            artworkImageURL: searchResult.largeThumbnailURL
        )

        searchResultDetailsVC.title = searchResult.title
        searchResultDetailsVC.navigationItem.backBarButtonItem?.title = "Search Results"

        // 📝 A standard `.pageSheet` modal style would be sweet here -- but, for the
        // sake of this project, it's also sweet to experiment with custom presentation view
        // controllers and animated transitions.
        let modalPresentationNavController = DimmedModalPresentationNavController(
            rootViewController: searchResultDetailsVC,
            height: searchResultDetailsVC.view.frame.height / 2
        )

        navController.present(modalPresentationNavController, animated: true)
    }
}
