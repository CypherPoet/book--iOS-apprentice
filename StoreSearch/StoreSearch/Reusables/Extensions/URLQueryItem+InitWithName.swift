//
//  URLQueryItem+InitWithName.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/24/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


extension URLQueryItem {
        
    // Enables using strongly typed constants with `URLQueryItem.init(name:value:)`
    enum ParamName {
        case term
        case limit
        case media
        
        var string: String {
            switch self {
            case .term:
                return "term"
            case .limit:
                return "limit"
            case .media:
                return "media"
            }
        }
    }
    
    
    init(name: ParamName, value: String) {
        self.init(name: name.string, value: value)
    }
}
