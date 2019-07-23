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
    
    private var dataSource: DataSource!
    
    private var searchResults: [SearchResult] = [] {
        didSet {
            DispatchQueue.main.async { self.updateDataSnapshot(with: self.searchResults) }
        }
    }
    
    private enum SearchState {
        case notStarted
        case completed(results: [SearchResult])
        case errored(message: String)
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
        
        Appearance.apply(to: searchBar)
        dataSource = makeTableViewDataSource()
        setupTableView()
        searchBar.becomeFirstResponder()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let dummyResults = [
                SearchResult(title: "🦊", artistName: "The Foxes"),
                SearchResult(title: "🐺", artistName: "The Wolves"),
                SearchResult(title: "🧝‍♂️", artistName: "The Elves"),
            ]
            
            self.currentSearchState = .completed(results: dummyResults)
        }
    }
}


// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        .topAttached
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#"The Search text is "\#(searchBar.text ?? "")""#)
        searchBar.resignFirstResponder()
        self.currentSearchState = .completed(results: [])
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
            emptyStateView.fadeOut()
        case .errored:
            break
        case .completed(let results):
            if results.isEmpty {
                emptyStateView.fadeIn { [weak self] in
                    self?.updateDataSnapshot(with: results)
                }
            } else {
                emptyStateView.fadeOut { [weak self] in
                    self?.updateDataSnapshot(with: results)
                }
            }
        }
    }
    
    
    func configure(_ cell: UITableViewCell, with searchResult: SearchResult) {
        guard let cell = cell as? SearchResultTableViewCell else {
            preconditionFailure("Unexpected cell type")
        }
        
        cell.viewModel = SearchResultTableViewCell.ViewModel(
            resultImage: nil,
            resultTitle: searchResult.title,
            artistName: searchResult.artistName
        )
    }
}
