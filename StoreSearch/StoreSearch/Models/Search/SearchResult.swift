//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/22/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


struct SearchResult {
    private let identifier = UUID()
    
    let artistName: String?
    let trackName: String?
}

extension SearchResult: Codable {}

extension SearchResult: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}


// MARK: - Computeds

extension SearchResult {
    
    var title: String { trackName ?? "" }
}


// MARK: - SearchResults

struct SearchResults {
    let resultCount: Int
    let results: [SearchResult]
}

extension SearchResults: Codable {}
