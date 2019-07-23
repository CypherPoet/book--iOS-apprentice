//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/22/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


struct SearchResult {
    let title: String
    let artistName: String
}

extension SearchResult: Hashable {}
extension SearchResult: Codable {}



struct SearchResults {
    let results: [SearchResult]
}

extension SearchResults: Codable {}
