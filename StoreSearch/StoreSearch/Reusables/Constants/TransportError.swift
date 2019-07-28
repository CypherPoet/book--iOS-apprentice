//
//  TransportError.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


enum TransportError: Error {
    case missingResult
    case missingResponse
    case unexpectedResponse(HTTPURLResponse)
    case missingData
}
