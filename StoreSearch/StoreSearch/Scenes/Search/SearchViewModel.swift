//
//  SearchViewModel.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

final class SearchViewModel {
    let searchController: UISearchController
    
    init(searchController: UISearchController) {
        self.searchController = searchController
    }
}



extension SearchViewModel {
    
    var selectedScopeIndex: Int { searchController.searchBar.selectedScopeButtonIndex }
    
    var currentSearchText: String? {
        guard
            let searchText = searchController.searchBar.text,
            !searchText.isEmpty
        else { return nil }
        
        return searchText
    }
    
    
    var selectedMediaType: APIMediaType {
        guard
            let scopeTitle = searchController.searchBar.scopeButtonTitles?[selectedScopeIndex],
            let mediaType = APIMediaType.allCases.first(where: { $0.titleText == scopeTitle })
        else {
            preconditionFailure("Unable to find selected media type")
        }
        
        return mediaType
    }
}
