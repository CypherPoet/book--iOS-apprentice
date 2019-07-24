//
//  Endpoint.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/22/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


struct Endpoint {
    let host: String
    let path: String
    let queryItems: [URLQueryItem]
}


extension Endpoint {
    private var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        return components
    }

    var url: URL? { urlComponents.url }
}


extension Endpoint {
    
    static func search(matching queryItems: [URLQueryItem]) -> Endpoint {
        Endpoint(
            host: "itunes.apple.com",
            path: "/search",
            queryItems: queryItems
        )
    }
}
