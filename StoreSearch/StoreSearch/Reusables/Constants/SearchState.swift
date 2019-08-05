//
//  SearchState.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/5/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


enum SearchState {
    case notStarted
    case inProgress
    case foundResults([SearchResult])
    case foundNoResults
    case errored(message: String? = nil)
}
