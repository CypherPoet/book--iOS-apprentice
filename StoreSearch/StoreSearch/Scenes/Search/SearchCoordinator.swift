////
////  SearchCoordinator.swift
////  StoreSearch
////
////  Created by Brian Sipple on 7/22/19.
////  Copyright © 2019 CypherPoet. All rights reserved.
////
//
//import UIKit
//
//
//final class SearchCoordinator: NSObject, NavigationCoordinator {
//    var navController: UINavigationController
//
//    private lazy var imageDownloaderFactory: ImageDownloaderFactory = .init()
//    private lazy var imageDownloader: ImageDownloader = imageDownloaderFactory.makeDownloader()
//    private let searchButtonTitles: [String] = APIMediaType.allTitles
//
//    private lazy var loadingViewController = LoadingViewController()
//    private var searchController: UISearchController!
//    private var searchResultsViewController: SearchResultsViewController!
//    private var resultDetailsViewController: SearchResultDetailsViewController!
//    private var resultDetailsModalNavController: DimmedModalPresentationNavController?
//
//
//    init(navController: UINavigationController) {
//        self.navController = navController
//    }
//}
//
//
//// MARK: - Coordinator
//extension SearchCoordinator: Coordinator {
//
//    func start() {
//        searchResultsViewController = SearchResultsViewController.instantiateFromStoryboard(
//            named: R.storyboard.search.name
//        )
//
//        searchController = UISearchController(searchResultsController: nil)
//
//        searchController.searchResultsUpdater = searchResultsViewController
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search the iTunes Store"
//        searchController.definesPresentationContext = true
//        searchController.searchBar.scopeButtonTitles = searchButtonTitles
//
//        searchResultsViewController.delegate = self
//        searchResultsViewController.imageDownloader = imageDownloader
//        searchResultsViewController.modelController = SearchModelController()
//        searchResultsViewController.viewModel = SearchViewModel(
//            scopeButtonTitles: searchButtonTitles,
//            selectedScopeIndex: 0
//        )
//
//        searchResultsViewController.navigationItem.searchController = searchController
//        searchResultsViewController.title = "iTunes Store Search"
//
//        Appearance.apply(to: searchController.searchBar)
//        Appearance.apply(to: navController.navigationBar)
//        navController.navigationBar.prefersLargeTitles = true
//
//        navController.setViewControllers([searchResultsViewController], animated: true)
//    }
//}
//
//
//// MARK: - SearchResultsViewControllerDelegate
//extension SearchCoordinator: SearchResultsViewControllerDelegate {
//
//    func viewControllerShouldDeselectItemsAfterSelection(_ controller: SearchResultsViewController) -> Bool {
//        true
//    }
//
//
//    func viewController(
//        _ controller: SearchResultsViewController,
//        didSelectDetailsFor searchResult: SearchResult
//    ) {
//        resultDetailsViewController = SearchResultDetailsViewController.instantiateFromStoryboard(
//            named: R.storyboard.searchResultDetails.name
//        )
//
//        resultDetailsViewController.viewModel = SearchResultDetailsViewController.ViewModel(
//            artistName: searchResult.artistName,
//            contentType: searchResult.contentType,
//            contentGenre: searchResult.primaryGenre,
//            price: searchResult.price,
//            storeURL: searchResult.storeURL,
//            artworkImageURL: searchResult.largeThumbnailURL
//        )
//
//        resultDetailsViewController.imageDownloader = imageDownloader
//        resultDetailsViewController.title = searchResult.title
//        resultDetailsViewController.navigationItem.backBarButtonItem?.title = "Search Results"
//
//        switch searchResultsViewController.traitCollection.verticalSizeClass {
//        case .regular, .unspecified:
//            presentResultDetailsModal()
//        case .compact:
//            presentResultDetailsPageSheet()
//        @unknown default:
//            presentResultDetailsPageSheet()
//        }
//    }
//
//
//    func viewControllerDidSwitchToCollectionView(_ controller: SearchResultsViewController) {
////        navController.navigationBar.backgroundColor = .clear
////        navController.navigationBar.prefersLargeTitles = false
//        navController.navigationBar.isHidden = true
//
//        searchController.searchBar.isHidden = true
//        searchController.isActive = false
//
//
//        if resultDetailsViewController != nil {
//            navController.dismiss(animated: true)
//            resultDetailsViewController = nil
//        }
//    }
//
//
//    func viewControllerDidSwitchToTableView(
//        _ controller: SearchResultsViewController,
//        with startingSearchText: String?
//    ) {
//        navController.navigationBar.isHidden = false
//        Appearance.apply(to: navController.navigationBar)
//
//
//        if resultDetailsViewController != nil {
//            navController.dismiss(animated: true)
//            resultDetailsViewController = nil
//        }
//
//        searchController.isActive = true
//        searchController.searchBar.isHidden = false
//
//        // 📝 Set this here so our update function can know this is what causes the change, and
//        // refrain from doing an additional fetch. (I feel like this
//        // approach can be cleaner, though 🙂)
//        searchResultsViewController.isSettingSearchBarOnViewSwitch = true
//        searchController.searchBar.text = startingSearchText
//
//        searchController.searchBar.becomeFirstResponder()
//    }
//}
//
//
//private extension SearchCoordinator {
//
//    // 📝 A standard `.pageSheet` modal style would be sweet
//    // here -- but, for the sake of this project, it's also
//    // sweet to experiment with custom presentation controllers.
//    func presentResultDetailsModal() {
//        let resultDetailsModalNavController = DimmedModalPresentationNavController(
//            rootViewController: resultDetailsViewController,
//            height: resultDetailsViewController.view.frame.height / 2
//        )
//
//        navController.present(resultDetailsModalNavController, animated: true)
//    }
//
//
//    func presentResultDetailsPageSheet() {
//        let childNavController = UINavigationController(
//            rootViewController: resultDetailsViewController
//        )
//
//        navController.navigationBar.isHidden = false
//        navController.present(childNavController, animated: true)
//    }
//}
