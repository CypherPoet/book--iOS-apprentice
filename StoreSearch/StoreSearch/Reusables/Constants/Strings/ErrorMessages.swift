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
        case body = "error_messages.networking_error.body"
        case title = "error_messages.networking_error.title"
    }
}


extension ErrorMessageStrings.NetworkingError: Localizable {
    var tableName: String { "ErrorMessages" }
}
