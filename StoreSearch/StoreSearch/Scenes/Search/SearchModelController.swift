//
//  SearchModelController.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/24/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


final class SearchModelController {
    typealias Loader = ModelLoader<SearchResults>
    typealias CompletionHandler = (Result<[SearchResult], Error>) -> Void
    
    let modelLoader: Loader
    
    
    init(modelLoader: Loader = Loader()) {
        self.modelLoader = modelLoader
    }
}


extension SearchModelController {
    
    func fetchResults(
        for searchText: String,
        then completionHandler: @escaping CompletionHandler
    ) {
        let queries = [
            URLQueryItem(name: .term, value: searchText),
            URLQueryItem(name: .limit, value: "50"),
        ]
        
        let endpoint = Endpoint.search(matching: queries)
        
        modelLoader.request(endpoint) { result in
            switch result {
            case .success(let searchResults):
                completionHandler(.success(searchResults.results))
            case .failure(let error):
                // TODO: Some more-robust error handling could be designed here
                print("Error while requesting data from endpoint: \(error.localizedDescription)")
                completionHandler(.failure(error))
            }
        }
    }
}
