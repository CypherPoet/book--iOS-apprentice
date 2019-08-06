//
//  SearchViewModel.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

struct SearchViewModel {
    var scopeButtonTitles: [String]
    var selectedScopeIndex: Int
    var currentSearchText: String?
}



extension SearchViewModel {
    var selectedScopeTitle: String { scopeButtonTitles[selectedScopeIndex] }
    
    var selectedMediaType: APIMediaType {
        guard
            let mediaType = APIMediaType.allCases.first(where: { $0.titleText == selectedScopeTitle })
        else {
            preconditionFailure("Unable to find selected media type")
        }
        
        return mediaType
    }
}
