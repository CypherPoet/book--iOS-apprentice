//
//  URLSession+DownloadTransport.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


extension URLSession: DownloadingTransport {
    
    func makeTask(
        for request: URLRequest,
        then completionHandler: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDownloadTask {
        
        let task = downloadTask(with: request) { (temporaryLocalURL, _, error) in
            
            guard error == nil else {
                return completionHandler(.failure(error!))
            }
            
            guard let url = temporaryLocalURL else {
                return completionHandler(.failure(TransportError.missingResult))
            }
            
            do {
                let data = try Data(contentsOf: url)
                completionHandler(.success(data))
            } catch {
                completionHandler(.failure(error))
            }
        }

        return task
    }
}
