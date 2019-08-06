//
//  SearchResultsViewControllerDelegate.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/5/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

protocol SearchResultsViewControllerDelegate: class {
    func viewController(_ controller: SearchResultsViewController, didSelectDetailsFor searchResult: SearchResult)
    
    func viewControllerDidSwitchToCollectionView(_ controller: SearchResultsViewController)
    
    func viewControllerDidSwitchToTableView(
        _ controller: SearchResultsViewController,
        with startingSearchText: String?
    )
}
