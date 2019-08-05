//
//  SearchResultsLandscapeViewController.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/1/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class SearchResultsLandscapeViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView!
    
    
    var searchResults: [SearchResult] = [] {
        didSet {
            DispatchQueue.main.async {
                self.updateDataSource(withNew: self.searchResults)
            }
        }
    }
    
    var currentSearchText: String?
    var imageDownloader: ImageDownloader!
    

    private var dataSource: DataSource?
    private var currentDataSnapshot: DataSourceSnapshot!
}


// MARK: - Collection Layout Structure
private extension SearchResultsLandscapeViewController {
    enum LayoutSection: CaseIterable {
        case all
    }
    
    enum SupplementaryViewKind {
        static let sectionHeader = "Section Header"
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<LayoutSection, SearchResult>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<LayoutSection, SearchResult>
    typealias SupplementaryViewProvider = UICollectionViewDiffableDataSource<LayoutSection, SearchResult>.SupplementaryViewProvider
}


// MARK: - Collection Layout Structure
private extension SearchResultsLandscapeViewController {
    
    func createLayout() -> UICollectionViewLayout {
        let resultItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 * (1 / 7)),
            heightDimension: .fractionalWidth(1.0 * (1 / 7))
        )
        
        let resultItem = NSCollectionLayoutItem(layoutSize: resultItemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [resultItem])
        group.interItemSpacing = NSCollectionLayoutSpacing.flexible(18)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 18
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let sectionHeader = collectionSectionHeader
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.extendsBoundary = true
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}



// MARK: - Computeds
extension SearchResultsLandscapeViewController {
    var currentResultCount: Int { currentDataSnapshot.numberOfItems }
    
    var collectionSectionHeader: NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        
        let headerAnchor = NSCollectionLayoutAnchor(edges: [.leading, .top], fractionalOffset: CGPoint(x: 0, y: -1.0))

        return .init(
            layoutSize: headerSize,
            elementKind: SupplementaryViewKind.sectionHeader,
            containerAnchor: headerAnchor
        )
    }
}


// MARK: - Lifecycle
extension SearchResultsLandscapeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(imageDownloader != nil, "No imageDownloader was set")

        dataSource = makeCollectionViewDataSource()
        dataSource?.supplementaryViewProvider = makeCollectionViewSupplementaryViewProvider()
        
        setupUI()
        setupCollectionView()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}


// MARK: - Misc Private Helpers
private extension SearchResultsLandscapeViewController {
    
    func setupUI() {
        view.backgroundColor = UIColor(patternImage: R.image.landscapeResultsBackground()!)
    }
    
    
    func makeCollectionViewDataSource() -> DataSource {
        DataSource(
            collectionView: collectionView,
            cellProvider: {
                [weak self] (collectionView, indexPath, searchResult) -> UICollectionViewCell? in
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: R.reuseIdentifier.searchResultsCollectionCell.identifier,
                    for: indexPath
                )
                
                self?.configure(cell, with: searchResult)

                return cell
            }
        )
    }
    
    
    func setupCollectionView() {
        collectionView.register(
            SearchResultsCollectionViewCell.nib,
            forCellWithReuseIdentifier: R.reuseIdentifier.searchResultsCollectionCell.identifier
        )
        
        collectionView.register(
            SearchResultsCollectionHeaderView.nib,
            forSupplementaryViewOfKind: SupplementaryViewKind.sectionHeader,
            withReuseIdentifier: R.reuseIdentifier.searchResultsCollectionHeader.identifier
        )
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    
    func makeCollectionViewSupplementaryViewProvider() -> SupplementaryViewProvider {
        return {
            [weak self] (
                collectionView: UICollectionView,
                kind: String,
                indexPath: IndexPath
            ) -> UICollectionReusableView? in
                
            guard kind == SupplementaryViewKind.sectionHeader else {
                preconditionFailure("Unknown kind for supplementary view")
            }
            
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: R.reuseIdentifier.searchResultsCollectionHeader.identifier,
                for: indexPath
            )
            
            self?.configure(headerView)
            
            return headerView
        }
    }
    
    
    func updateDataSource(withNew searchResults: [SearchResult]) {
        guard let dataSource = dataSource else { return }
        
        currentDataSnapshot = dataSource.snapshot()
        
        currentDataSnapshot.appendSections([.all])
        currentDataSnapshot.appendItems(searchResults)
        
        dataSource.apply(currentDataSnapshot, animatingDifferences: true)
    }

    
    func configure(_ cell: UICollectionViewCell, with searchResult: SearchResult) {
        guard let cell = cell as? SearchResultsCollectionViewCell else {
            preconditionFailure("Unexpected cell type")
        }
        
        if let largeThumbnailURL = searchResult.largeThumbnailURL {
            cell.imageDownloadingToken = imageDownloader.downloadImage(
                from: largeThumbnailURL,
                then: { result in
                    if case .success(let image) = result {
                        cell.resultImage = image
                    }
                }
            )
        }
    }
    
    
    func configure(_ headerView: UICollectionReusableView) {
        guard let headerView = headerView as? SearchResultsCollectionHeaderView else {
            preconditionFailure("Unexpected view type")
        }
        
        headerView.viewModel = SearchResultsCollectionHeaderView.ViewModel(
            resultCount: currentResultCount,
            searchText: currentSearchText
        )
    }

}


extension SearchResultsLandscapeViewController: Storyboarded {}
