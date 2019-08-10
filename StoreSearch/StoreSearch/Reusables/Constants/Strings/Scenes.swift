//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/10/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation

enum SceneStrings {
    
    enum SearchResults {
        enum Item: String {
            case untitled = "scenes.search_results.item.untitled"
            case unknownArtist = "scenes.search_results.item.unknown_artist"
        }
    }
    
    
    enum SearchResultDetails: String {
        case unknownArtist = "scenes.search_result_details.unknown_artist"
        case free = "scenes.search_result_details.free"
    }
}



extension SceneStrings.SearchResults.Item: Localizable {
    var tableName: String { "Scenes" }
}
extension SceneStrings.SearchResultDetails: Localizable {
    var tableName: String { "Scenes" }
}
