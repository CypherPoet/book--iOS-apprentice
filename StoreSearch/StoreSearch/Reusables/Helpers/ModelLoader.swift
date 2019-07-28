//
//  ModelLoader.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/24/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


final class ModelLoader<Model: Decodable> {
    typealias LoadingCompletionHandler = (Result<Model, Error>) -> Void
    
    private let transport: RequestTransport
    private let decoder: JSONDecoder
    
    
    init(transport: RequestTransport = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.transport = transport
        self.decoder = decoder
    }
}


extension ModelLoader {
    enum LoaderError: Error {
        case invalidURL
    }
}


extension ModelLoader {
    
    func request(
        _ endpoint: Endpoint,
        on queue: DispatchQueue = .global(qos: .userInitiated),
        then loadingCompletionHandler: @escaping LoadingCompletionHandler
    ) -> DataTaskToken {
        guard let url = endpoint.url else {
            preconditionFailure("Failed to construct URL from endpoint")
        }
        
        let request = URLRequest(url: url)
        
        let dataTask = transport.makeTask(for: request) { [weak self] dataResult in
            self?.handle(dataResult, using: loadingCompletionHandler)
        }
        
        queue.async {
            dataTask.resume()
        }
        
        return DataTaskToken(task: dataTask)
    }
}


private extension ModelLoader {
    
    func handle(
        _ dataResult: Result<Data, Error>,
        using loadingCompletionHandler: LoadingCompletionHandler
    ) {
        switch dataResult {
        case .success(let data):
            do {
                let model = try decoder.decode(Model.self, from: data)
                loadingCompletionHandler(.success(model))
            } catch {
                loadingCompletionHandler(.failure(error))
            }
        case .failure(let error):
            handleDataError(error, using: loadingCompletionHandler)
        }
    }
    
    
    func handleDataError(
        _ error: Error,
        using loadingCompletionHandler: LoadingCompletionHandler
    ) {
        switch error {
        case (let nsError as NSError?) where nsError != nil:
            if nsError!.code == NSURLErrorCancelled {
                return
            }
        default:
            loadingCompletionHandler(.failure(error))
        }
    }
}
