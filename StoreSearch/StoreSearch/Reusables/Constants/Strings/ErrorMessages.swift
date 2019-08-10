//
//  ErrorMessages.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/10/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


enum ErrorMessageStrings {
    
    enum NetworkingError: String {
        case body = "networking-error.body"
        case title = "networking-error.title"
    }
}


extension ErrorMessageStrings.NetworkingError: Localizable {
    var tableName: String { "ErrorMessages" }
}
