//
//  URLSession+Transport.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/24/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


extension URLSession: RequestTransport {
    
    func makeTask(
        for request: URLRequest,
        then completionHandler: @escaping ((Result<Data, Error>) -> Void)
    ) -> URLSessionDataTask {
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
        
        return task
    }
}
