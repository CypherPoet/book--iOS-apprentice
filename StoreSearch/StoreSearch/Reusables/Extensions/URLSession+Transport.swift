//
//  URLSession+Transport.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/24/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


extension URLSession {
    enum TransportError: Error {
        case missingResponse
        case unexpectedResponse(HTTPURLResponse)
        case missingData
    }
}


extension URLSession: Transport {
    
    func send(
        request: URLRequest,
        then completionHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        let task = dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                return completionHandler(.failure(error!))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return completionHandler(.failure(TransportError.missingResponse))
            }
                
            guard response.statusCode == 200 else {
                return completionHandler(.failure(TransportError.unexpectedResponse(response)))
            }
            
            guard let data = data else {
                return completionHandler(.failure(TransportError.missingData))
            }
            
            completionHandler(.success(data))
        }
        
        // 🚀
        task.resume()
    }
}
