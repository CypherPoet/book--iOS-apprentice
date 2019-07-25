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
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var emptyStateView: UIView!
    @IBOutlet private var loadingSpinnerViewContainer: UIView!
    @IBOutlet private var loadingSpinner: UIActivityIndicatorView!
    
    
    var modelController: SearchModelController!
    
    
    private var dataSource: DataSource!
    
    private var searchResults: [SearchResult] = [] {
        didSet {
            DispatchQueue.main.async { self.updateDataSnapshot(with: self.searchResults) }
        }
    }
    
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
        
        Appearance.apply(to: searchBar)
        dataSource = makeTableViewDataSource()
        setupTableView()
        searchBar.becomeFirstResponder()
    }
}


// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        .topAttached
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard
            let searchText = searchBar.text,
            !searchText.isEmpty
        else { return }

        searchBar.resignFirstResponder()
        fetchResults(for: searchText)
    }
}


// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        searchBar.resignFirstResponder()
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
    
    
    func updateDataSnapshot(with items: [SearchResult]) {
        let snapshot = DataSourceSnapshot()
        
        snapshot.appendSections([.all])
        snapshot.appendItems(items)

        dataSource.apply(snapshot)
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
                    self?.updateDataSnapshot(with: results)
                }
            } else {
                SearchResults.sortAscending(&results)

                emptyStateView.fadeOut { [weak self] in
                    self?.updateDataSnapshot(with: results)
                }
            }
        }
    }
    
    
    func stopLoadingSpinner() {
        loadingSpinnerViewContainer.fadeOut()
        loadingSpinner.stopAnimating()
    }
    
    
    func configure(_ cell: UITableViewCell, with searchResult: SearchResult) {
        guard let cell = cell as? SearchResultTableViewCell else {
            preconditionFailure("Unexpected cell type")
        }
        
        cell.viewModel = SearchResultTableViewCell.ViewModel(
            resultImage: nil,
            resultTitle: searchResult.title,
            artistName: searchResult.artistName,
            contentType: searchResult.contentType
        )
    }
    
    
    func fetchResults(for searchText: String) {
        currentSearchState = .inProgress
        
        modelController.fetchResults(for: searchText) { [weak self] fetchResult in
            guard let self = self else { return }
            
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
