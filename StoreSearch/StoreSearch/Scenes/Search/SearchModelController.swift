//
//  SearchModelController.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/24/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


final class SearchModelController {
    typealias CompletionHandler = (Result<[SearchResult], Error>) -> Void
    
    private let modelLoader: ModelLoader<SearchResults>

    
    init(modelLoader: ModelLoader<SearchResults> = .init()) {
        self.modelLoader = modelLoader
    }
}


extension SearchModelController {
    
    func fetchResults(
        for searchText: String,
        in mediaType: APIMediaType,
        then completionHandler: @escaping CompletionHandler
    ) -> DataTaskToken {
        let queries = [
            URLQueryItem(name: .term, value: searchText),
            URLQueryItem(name: .media, value: mediaType.queryParamValue),
            URLQueryItem(name: .limit, value: "50"),
        ]
        
        let endpoint = Endpoint.search(matching: queries)
        
        return modelLoader.request(endpoint) { result in
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
