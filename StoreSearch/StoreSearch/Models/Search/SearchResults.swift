//
//  SearchResults.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/25/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


struct SearchResults {
    let resultCount: Int
    let results: [SearchResult]
}

extension SearchResults: Codable {}


// MARK: - Core Methods

extension SearchResults {
    
    static func sortAscending(_ results: inout [SearchResult]) {
        results.sort {
            ($0.title ?? "").localizedStandardCompare($1.title ?? "") == .orderedAscending
        }
    }
}
