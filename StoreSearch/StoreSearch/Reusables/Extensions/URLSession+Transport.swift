//
//  URLSession+Transport.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/24/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


extension URLSession: Transport {
    
    func send(
        request: URLRequest,
        then completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        let task = dataTask(with: request) { (data, _, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data {
                completionHandler(.success(data))
            }
        }
        
        // 🚀
        task.resume()
    }
}
