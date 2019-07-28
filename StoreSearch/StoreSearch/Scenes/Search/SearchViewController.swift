//
//  SearchViewController.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/22/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, Storyboarded {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var emptyStateView: UIView!
    @IBOutlet private var loadingSpinnerViewContainer: UIView!
    @IBOutlet private var loadingSpinner: UIActivityIndicatorView!
    
    
    var modelController: SearchModelController!
    var viewModel: SearchViewModel!
    var imageDownloaderFactory: ImageDownloaderFactory = .init()
    
    
    private lazy var imagedownLoader: ImageDownloader = imageDownloaderFactory.makeDownloader()
    private var dataSource: DataSource!
    private var currentFetchToken: DataTaskToken?
    
    private enum SearchState {
        case notStarted
        case inProgress
        case completed(finding: [SearchResult])
        case errored(message: String? = nil)
    }
    
    private var currentSearchState: SearchState = .notStarted {
        didSet { DispatchQueue.main.async { self.searchStateChanged() } }
    }
}


// MARK: - Table View Structure

extension SearchViewController {
    enum TableSection: CaseIterable {
        case all
    }
    
    typealias DataSource = UITableViewDiffableDataSource<TableSection, SearchResult>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<TableSection, SearchResult>
}


// MARK: - Lifecycle

extension SearchViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(modelController != nil, "No SearchModelController was set")
        assert(viewModel != nil, "No viewModel was set")
        
        dataSource = makeTableViewDataSource()
        setupTableView()
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = viewModel.currentSearchText else { return }
        
        fetchResults(for: searchText)
    }
}


// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        guard let cell = cell as? SearchResultTableViewCell else {
            preconditionFailure("Unknown cell type")
        }
        
        guard let searchResult = dataSource.itemIdentifier(for: indexPath) else {
            preconditionFailure("No result item found")
        }

        guard let thumbnailURL = searchResult.smallThumbnailURL else { return }
            
        cell.imageDownloadToken = imagedownLoader.downloadImage(from: thumbnailURL) { result in
            switch result {
            case .success(let image):
                cell.viewModel?.downloadedThumbnailImage = image
            case .failure(let error):
                print("Error while attempting to download thumbnail image: \(error.localizedDescription)")
            }
        }
    }
}


// MARK: - Private Helpers

private extension SearchViewController {

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
        let snapshot = DataSourceSnapshot()
        
        snapshot.appendSections([.all])
        snapshot.appendItems(newItems)

        dataSource.apply(snapshot, animatingDifferences: animate)
    }


    func searchStateChanged() {
        switch currentSearchState {
        case .notStarted:
            stopLoadingSpinner()
            emptyStateView.fadeOut()
        case .inProgress:
            emptyStateView.fadeOut { [weak self] in
                self?.loadingSpinnerViewContainer.fadeIn()
                self?.loadingSpinner.startAnimating()
            }
        case .errored:
            stopLoadingSpinner()
        case .completed(var results):
            stopLoadingSpinner()
            
            if results.isEmpty {
                emptyStateView.fadeIn { [weak self] in
                    self?.updateDataSnapshot(withNewItems: results)
                }
            } else {
                SearchResults.sortAscending(&results)

                emptyStateView.fadeOut { [weak self] in
                    self?.updateDataSnapshot(withNewItems: results)
                }
            }
        }
    }
    
    
    func stopLoadingSpinner() {
        loadingSpinner.stopAnimating()
        loadingSpinnerViewContainer.fadeOut()
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
                    self.currentSearchState = .completed(finding: results)
                case .failure:
                    self.showNetworkingError()
                    self.currentSearchState = .errored()
                }
            }
        }
    }
}
