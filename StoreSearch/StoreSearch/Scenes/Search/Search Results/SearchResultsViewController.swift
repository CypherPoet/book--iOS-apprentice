//
//  SearchViewController.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/22/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


class SearchResultsViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var emptyStateView: UIView!

    
    weak var delegate: SearchResultsViewControllerDelegate?
    var modelController: SearchModelController!
    var viewModel: SearchViewModel!
    var imageDownloader: ImageDownloader!
    var isSettingSearchBarOnViewSwitch = false
    
    
    private var dataSource: DataSource?
    private var currentDataSnapshot: DataSourceSnapshot!
    private var currentFetchToken: DataTaskToken?
    private var landscapeVC: SearchResultsLandscapeViewController?
    
    lazy var loadingVC = LoadingViewController.instantiateFromStoryboard(
        named: R.storyboard.loadingViewController.name
    )
        
    private enum ViewMode {
        case table(startingSearchText: String? = nil)
        case collection
    }
    
    private var currentSearchState: SearchState = .notStarted {
        didSet {
            DispatchQueue.main.async {
                self.searchStateChanged(from: oldValue)
                self.landscapeVC?.currentSearchState = self.currentSearchState
            }
        }
    }
    
    private var currentViewMode: ViewMode = .table() {
        didSet { DispatchQueue.main.async { self.viewModeChanged() } }
    }
}


// MARK: - Table View Structure
extension SearchResultsViewController {
    enum TableSection: CaseIterable {
        case all
    }
    
    typealias DataSource = UITableViewDiffableDataSource<TableSection, SearchResult>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<TableSection, SearchResult>
}


// MARK: - Computeds
extension SearchResultsViewController {
    var currentSearchResults: [SearchResult] {
        currentDataSnapshot != nil ? currentDataSnapshot.itemIdentifiers : []
    }
}


// MARK: - Lifecycle
extension SearchResultsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(modelController != nil, "No SearchModelController was set")
        assert(viewModel != nil, "No viewModel was set")
        assert(imageDownloader != nil, "No imageDownloader was set")

        dataSource = makeTableViewDataSource()
        setupTableView()
    }
    
    
    override func willTransition(
        to newCollection: UITraitCollection,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.willTransition(to: newCollection, with: coordinator)
        
        switch newCollection.verticalSizeClass {
        case .compact:
            showLandscapeViewController(with: coordinator)
        case .regular, .unspecified:
            hideLandscapeViewController(with: coordinator)
        @unknown default:
            hideLandscapeViewController(with: coordinator)
        }
    }
}


// MARK: - UISearchResultsUpdating
extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.currentSearchText = searchController.searchBar.text
        viewModel.selectedScopeIndex = searchController.searchBar.selectedScopeButtonIndex
  
        guard !isSettingSearchBarOnViewSwitch else {
            isSettingSearchBarOnViewSwitch = false
            return
        }
        
        if let currentSearchText = viewModel.currentSearchText {
            if !currentSearchText.isEmpty {
                fetchResults(for: currentSearchText)
            } else {
                currentSearchState = .notStarted
            }
        }
    }
}


// MARK: - UITableViewDelegate
extension SearchResultsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let searchResult = dataSource?.itemIdentifier(for: indexPath) else {
            preconditionFailure("No search result found for selected cell.")
        }
        
        delegate?.viewController(self, didSelectDetailsFor: searchResult)
    }
    
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        guard let cell = cell as? SearchResultTableViewCell else {
            preconditionFailure("Unknown cell type")
        }
        
        guard let searchResult = dataSource?.itemIdentifier(for: indexPath) else {
            preconditionFailure("No result item found")
        }

        guard let thumbnailURL = searchResult.smallThumbnailURL else { return }
            
        cell.imageDownloadToken = imageDownloader.downloadImage(from: thumbnailURL) { result in
            switch result {
            case .success(let image):
                cell.viewModel?.downloadedThumbnailImage = image
            case .failure(let error):
                print("Error while attempting to download thumbnail image: \(error.localizedDescription)")
            }
        }
    }
}


// MARK: - SearchResultsCollectionViewControllerDelegate
extension SearchResultsViewController: SearchResultsCollectionViewControllerDelegate {
    func viewController(
        _ controller: SearchResultsLandscapeViewController,
        didSelectDetailsFor searchResult: SearchResult
    ) {
        delegate?.viewController(self, didSelectDetailsFor: searchResult)
    }
}


// MARK: - Private Helpers
private extension SearchResultsViewController {

    func makeTableViewDataSource() -> DataSource {
        DataSource(
            tableView: tableView,
            cellProvider: { [weak self] (tableView, indexPath, searchResult) -> UITableViewCell? in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: R.reuseIdentifier.searchTableCell.identifier,
                    for: indexPath
                )
                
                self?.configure(cell, with: searchResult)
                
                return cell
            }
        )
    }
    
    
    func setupTableView() {
        let resultCellNib = SearchResultTableViewCell.nib
        
        tableView.register(
            resultCellNib,
            forCellReuseIdentifier: R.reuseIdentifier.searchTableCell.identifier
        )
        tableView.delegate = self
    }
    
    
    func updateDataSnapshot(withNewItems newItems: [SearchResult], animate: Bool = true) {
        currentDataSnapshot = DataSourceSnapshot()
        
        currentDataSnapshot.appendSections([.all])
        currentDataSnapshot.appendItems(newItems)

        dataSource?.apply(currentDataSnapshot, animatingDifferences: animate)
    }


    func searchStateChanged(from oldState: SearchState) {
        switch (oldState, currentSearchState) {
        case (.inProgress, .inProgress):
            break
        case (_, .inProgress):
            showLoadingSpinner()
        case (_, _):
            hideLoadingSpinner()
        }
        

        switch currentSearchState {
        case .notStarted:
            emptyStateView.fadeOut()
            updateDataSnapshot(withNewItems: [])
        case .inProgress:
            emptyStateView.fadeOut()
        case .errored:
            break
        case .foundResults(var results):
            SearchResults.sortAscending(&results)
            emptyStateView.fadeOut { [weak self] in
                self?.updateDataSnapshot(withNewItems: results)
            }
        case .foundNoResults:
            emptyStateView.fadeIn { [weak self] in
                self?.updateDataSnapshot(withNewItems: [])
            }
        }
    }

    
    func viewModeChanged() {
        switch currentViewMode {
        case .collection:
            delegate?.viewControllerDidSwitchToCollectionView(self)
        case .table(let startingSearchText):
            delegate?.viewControllerDidSwitchToTableView(self, with: startingSearchText)
        }
    }

    
    func configure(_ cell: UITableViewCell, with searchResult: SearchResult) {
        guard let cell = cell as? SearchResultTableViewCell else {
            preconditionFailure("Unexpected cell type")
        }
  
        cell.configure(with: searchResult)
    }
    
    
    func fetchResults(for searchText: String) {
        currentFetchToken?.cancel()
        currentSearchState = .inProgress
        
        let mediaType = viewModel.selectedMediaType
        
        currentFetchToken = modelController.fetchResults(
            for: searchText,
            in: mediaType
        ) { [weak self] fetchResult in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch fetchResult {
                case .success(let results):
                    self.currentSearchState = results.isEmpty ? .foundNoResults : .foundResults(results)
                case .failure:
                    self.showNetworkingError()
                    self.currentSearchState = .errored()
                }
            }
        }
    }
    
    
    func showLandscapeViewController(with coordinator: UIViewControllerTransitionCoordinator) {
        guard landscapeVC == nil else { return }
        
        landscapeVC = SearchResultsLandscapeViewController.instantiateFromStoryboard(
            named: R.storyboard.searchLandscape.name
        )
        
        guard let landscapeVC = landscapeVC else { return }
        
        landscapeVC.currentSearchText = viewModel.currentSearchText
        landscapeVC.imageDownloader = imageDownloader
        landscapeVC.currentSearchState = currentSearchState
        landscapeVC.delegate = self
        
        landscapeVC.view.frame = view.bounds
        
        addChild(landscapeVC)
        view.addSubview(landscapeVC.view)
        
        coordinator.animate(
            alongsideTransition: { _ in
                landscapeVC.view.alpha = 1
                self.currentViewMode = .collection
            },
            completion: { _ in
                landscapeVC.didMove(toParent: self)
            }
        )
    }
    
    
    func hideLandscapeViewController(with coordinator: UIViewControllerTransitionCoordinator) {
        if let childLandscapeVC = landscapeVC {
            childLandscapeVC.willMove(toParent: nil)
            
            coordinator.animate(
                alongsideTransition: { _ in
                    childLandscapeVC.view.alpha = 0
                },
                completion: { _ in
                    childLandscapeVC.view.removeFromSuperview()
                    childLandscapeVC.removeFromParent()
                    self.landscapeVC = nil
                    self.currentViewMode = .table(startingSearchText: childLandscapeVC.currentSearchText)
                }
            )
        }
    }
}

extension SearchResultsViewController: Storyboarded {}
extension SearchResultsViewController: LoadingViewControllerToggling {}
