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

    private lazy var imageDownloaderFactory: ImageDownloaderFactory = .init()
    private lazy var imageDownloader: ImageDownloader = imageDownloaderFactory.makeDownloader()

    private var searchController: UISearchController!
    private var searchResultsViewController: SearchResultsViewController!
    private var resultDetailsModalNavController: DimmedModalPresentationNavController?
    
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
}


// MARK: - Coordinator
extension SearchCoordinator: Coordinator {

    func start() {
        searchResultsViewController = SearchResultsViewController.instantiateFromStoryboard(
            named: R.storyboard.search.name
        )
        
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = searchResultsViewController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search the iTunes Store"
        searchController.definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = APIMediaType.allTitles

        searchResultsViewController.delegate = self
        searchResultsViewController.modelController = SearchModelController()
        searchResultsViewController.viewModel = SearchViewModel(searchController: searchController)
        searchResultsViewController.imageDownloader = imageDownloader
        
        searchResultsViewController.navigationItem.searchController = searchController
        searchResultsViewController.title = "iTunes Store Search"
        
        Appearance.apply(to: searchController.searchBar)
        Appearance.apply(to: navController.navigationBar)
        navController.navigationBar.prefersLargeTitles = true
        
        navController.setViewControllers([searchResultsViewController], animated: true)
    }
}


// MARK: - SearchViewControllerDelegate
extension SearchCoordinator: SearchResultsViewControllerDelegate {
    
    func viewController(
        _ controller: SearchResultsViewController,
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

        searchResultDetailsVC.imageDownloader = imageDownloader
        searchResultDetailsVC.title = searchResult.title
        searchResultDetailsVC.navigationItem.backBarButtonItem?.title = "Search Results"

        // 📝 A standard `.pageSheet` modal style would be sweet here -- but, for the
        // sake of this project, it's also sweet to experiment with custom presentation view
        // controllers and animated transitions.
        resultDetailsModalNavController = DimmedModalPresentationNavController(
            rootViewController: searchResultDetailsVC,
            height: searchResultDetailsVC.view.frame.height / 2
        )

        navController.present(resultDetailsModalNavController!, animated: true)
    }
    
    
    func viewControllerDidSwitchToCollectionView(_ controller: SearchResultsViewController) {
//        navController.navigationBar.backgroundColor = .clear
//        navController.navigationBar.prefersLargeTitles = false
        navController.navigationBar.isHidden = true
        
        searchController.searchBar.isHidden = true
        searchController.isActive = false
        
        if resultDetailsModalNavController != nil {
            navController.dismiss(animated: true)
            resultDetailsModalNavController = nil
        }
    }
    
    
    func viewControllerDidSwitchToTableView(_ controller: SearchResultsViewController) {
        searchController.isActive = true
        searchController.searchBar.isHidden = false
        searchController.searchBar.becomeFirstResponder()
        
        navController.navigationBar.isHidden = false
        Appearance.apply(to: navController.navigationBar)
    }
}
