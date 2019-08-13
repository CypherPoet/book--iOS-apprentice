//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/10/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


enum SceneStrings {
    
    enum SearchResults: String {
        case title = "scenes.search_results.title"
        
        enum SearchBar: String {
            case placeholder = "scenes.search_results.search_bar.placeholder"
        }
        
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


private let stringsTableName = "Scenes"

extension SceneStrings.SearchResults: Localizable {
    var tableName: String { stringsTableName }
}
extension SceneStrings.SearchResults.SearchBar: Localizable {
    var tableName: String { stringsTableName }
}
extension SceneStrings.SearchResults.Item: Localizable {
    var tableName: String { stringsTableName }
}
extension SceneStrings.SearchResultDetails: Localizable {
    var tableName: String { stringsTableName }
}
