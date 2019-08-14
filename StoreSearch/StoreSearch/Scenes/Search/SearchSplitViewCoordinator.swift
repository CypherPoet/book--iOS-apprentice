//
//  SearchSplitViewCoordinator.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/11/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


final class SearchSplitViewCoordinator {
    private let window: UIWindow

    private lazy var imageDownloaderFactory: ImageDownloaderFactory = .init()
    private lazy var imageDownloader: ImageDownloader = imageDownloaderFactory.makeDownloader()
    private let searchButtonTitles: [String] = APIMediaType.allTitles

    private var splitViewController: SearchSplitViewController!
    private var searchController: UISearchController!
    private var searchResultsViewController: SearchResultsViewController!
    private var detailsContainerViewController: SplitViewDetailsContainerViewController!
    private var startingDetailsViewController: SplitViewStartingDetailsViewController!
    private var searchResultsNavController: UINavigationController!
    private var detailsViewNavController: UINavigationController!
    private lazy var loadingViewController = LoadingViewController()
    
    private lazy var resultDetailsContainerViewController = UIViewController()
    private var resultDetailsViewController: SearchResultDetailsViewController!
    
    
    init(window: UIWindow) {
        self.window = window
    }
}


// MARK: - Coordinator
extension SearchSplitViewCoordinator: Coordinator {
    var rootViewController: UIViewController { splitViewController }
    
    func start() {
        splitViewController = SearchSplitViewController()
        
        setupSearchResultsController()
        setupDetailsContainer()
        
        searchResultsNavController = UINavigationController(rootViewController: searchResultsViewController)
        detailsViewNavController = UINavigationController(rootViewController: detailsContainerViewController)
        
        Appearance.apply(to: searchController.searchBar)
        Appearance.apply(to: searchResultsNavController.navigationBar)
        Appearance.apply(to: detailsViewNavController.navigationBar)

        searchResultsNavController.navigationBar.prefersLargeTitles = true
        
        splitViewController.viewControllers = [searchResultsNavController, detailsViewNavController]
        splitViewController.delegate = self
        
        window.rootViewController = splitViewController
    }
}


// MARK: - Private Helpers
extension SearchSplitViewCoordinator {
    
    func setupSearchResultsController() {
        searchResultsViewController = SearchResultsViewController.instantiateFromStoryboard(
            named: R.storyboard.search.name
        )
                
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = searchResultsViewController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = SceneStrings.SearchResults.SearchBar.placeholder.localized
        searchController.definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = searchButtonTitles

        searchResultsViewController.delegate = self
        searchResultsViewController.isInSplitView = true
        searchResultsViewController.imageDownloader = imageDownloader
        searchResultsViewController.modelController = SearchModelController()
        searchResultsViewController.viewModel = SearchViewModel(
            scopeButtonTitles: searchButtonTitles,
            selectedScopeIndex: 0
        )
        
        searchResultsViewController.navigationItem.searchController = searchController
        searchResultsViewController.title = SceneStrings.SearchResults.title.localized
    }
    
    
    func setupDetailsContainer() {
        detailsContainerViewController = SplitViewDetailsContainerViewController
            .instantiateFromStoryboard(named: R.storyboard.search.name)

        detailsContainerViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        detailsContainerViewController.navigationItem.leftItemsSupplementBackButton = true
        detailsContainerViewController.delegate = self
        
        startingDetailsViewController = SplitViewStartingDetailsViewController
            .instantiateFromStoryboard(named: R.storyboard.splitViewStartingDetails.name)
        startingDetailsViewController.title = R.string.infoPlist.cfBundleDisplayName()

        detailsContainerViewController.add(child: startingDetailsViewController)
    }
    
    
    func show(_ resultDetailsViewController: SearchResultDetailsViewController) {
        if splitViewController.isViewHorizontallyCompact {
            let childNavController = UINavigationController(rootViewController: resultDetailsViewController)

            resultDetailsViewController.showsCustomCloseButton = true
            searchResultsNavController.present(childNavController, animated: true)
        } else {
            resultDetailsViewController.showsCustomCloseButton = false
            detailsViewNavController.navigationBar.prefersLargeTitles = true
//            detailsViewNavController.setViewControllers([resultDetailsViewController], animated: true)
//            detailsViewNavController.pushViewController(resultDetailsViewController, animated: true)
            detailsContainerViewController.children.first?.performRemoval()
            detailsContainerViewController.add(
                child: resultDetailsViewController,
                usingFrame: detailsContainerViewController.view.bounds
            )
        }
    }
}

    
// MARK: - SearchResultsViewControllerDelegate
extension SearchSplitViewCoordinator: SearchResultsViewControllerDelegate {
    
    func viewControllerShouldDeselectItemsAfterSelection(
        _ controller: SearchResultsViewController
    ) -> Bool {
        return splitViewController.traitCollection.horizontalSizeClass == .compact
    }
    
    
    func viewController(
        _ controller: SearchResultsViewController,
        didSelectDetailsFor searchResult: SearchResult
    ) {
        let resultDetailsViewController = SearchResultDetailsViewController.instantiateFromStoryboard(
            named: R.storyboard.searchResultDetails.name
        )
        
        resultDetailsViewController.viewModel = SearchResultDetailsViewController.ViewModel(
            artistName: searchResult.artistName,
            contentType: searchResult.contentType,
            contentGenre: searchResult.primaryGenre,
            price: searchResult.price,
            storeURL: searchResult.storeURL,
            artworkImageURL: searchResult.largeThumbnailURL
        )

        resultDetailsViewController.imageDownloader = imageDownloader
        resultDetailsViewController.title = searchResult.title
        
//        resultDetailsViewController.delegate = self
        
        if splitViewController.displayMode != .allVisible {
            splitViewController.hideMasterPane()
        }
        
        show(resultDetailsViewController)
    }

    
    func viewControllerDidSwitchToCollectionView(_ controller: SearchResultsViewController) {
        
    }
    
    
    func viewControllerDidSwitchToTableView(_ controller: SearchResultsViewController, with startingSearchText: String?) {
        
    }
    
    
    func viewControllerDidAppear(_ controller: SearchResultsViewController) {
        if UIDevice.current.userInterfaceIdiom != .pad {
            controller.navigationItem.searchController?.becomeFirstResponder()
        }
    }
}


// MARK: - SplitViewDetailsContainerViewControllerDelegate
extension SearchSplitViewCoordinator: SplitViewDetailsContainerViewControllerDelegate {
    
    func viewControllerDidTapAppMenuButton(_ controller: SplitViewDetailsContainerViewController) {
        let appMenuVC = AppMenuTableViewController.instantiateFromStoryboard(
            named: R.storyboard.appMenu.name
        )
        
        controller.present(appMenuVC, animated: true)
    }
}


// MARK: - UISplitViewControllerDelegate
extension SearchSplitViewCoordinator: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        true
    }
}
