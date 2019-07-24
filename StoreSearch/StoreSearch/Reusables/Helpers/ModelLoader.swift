//
//  ModelLoader.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/24/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


final class ModelLoader<Model: Decodable> {
    typealias DecodingCompletionHandler = (Result<Model, Error>) -> Void
    
    private let transport: Transport
    private let decoder: JSONDecoder
    
    
    init(transport: Transport = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.transport = transport
        self.decoder = decoder
    }
}


extension ModelLoader {
    enum LoaderError: Swift.Error {
        case invalidURL
    }
}


extension ModelLoader {
    
    func request(
        _ endpoint: Endpoint,
        on queue: DispatchQueue = .global(qos: .userInitiated),
        then decodingCompletionHandler: @escaping DecodingCompletionHandler
    ) {
        guard let url = endpoint.url else {
            return decodingCompletionHandler(.failure(LoaderError.invalidURL))
        }
        
        let request = URLRequest(url: url)
        
        queue.async { [weak self] in
            self?.transport.send(request: request) { dataResult in
                self?.handle(dataResult, using: decodingCompletionHandler)
            }
        }
        
    }
}


private extension ModelLoader {
    
    func handle(
        _ dataResult: Result<Data, Error>,
        using decodingCompletionHandler: DecodingCompletionHandler
    ) {
        do {
            let model = try decoder.decode(Model.self, from: dataResult.get())
            decodingCompletionHandler(.success(model))
        } catch {
            decodingCompletionHandler(.failure(error))
        }
    }
}
