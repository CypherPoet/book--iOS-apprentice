//
//  Transport.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/24/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


protocol Transport {
    
    func send(
        request: URLRequest,
        then completionHandler: @escaping (Result<Data, Error>) -> Void
    )
}
