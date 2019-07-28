//
//  SessionImageLoader.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


extension ImageDownloaderFactory {
    
    final class SessionImageDownloader {
        private let transport: DownloadingTransport
        private let queue: DispatchQueue
        
        init(transport: DownloadingTransport, queue: DispatchQueue) {
            self.transport = transport
            self.queue = queue
        }
    }
}


extension ImageDownloaderFactory.SessionImageDownloader {
    enum DownloaderError: Error {
        case invalidImageData
    }
}


extension ImageDownloaderFactory.SessionImageDownloader: ImageDownloader {
    
    func downloadImage(
        from url: URL,
        then completionHandler: @escaping ImageDownloader.CompletionHandler
    ) -> DownloadTaskToken {

        let urlRequest = URLRequest(url: url)
        
        let downLoadTask = transport.makeTask(for: urlRequest) { [weak self] (dataResult) in
            self?.handle(dataResult, using: completionHandler)
        }
        
        queue.async {
            downLoadTask.resume()
        }
        
        return DownloadTaskToken(task: downLoadTask)
    }
}


private extension ImageDownloaderFactory.SessionImageDownloader {
    
    func handle(
        _ dataResult: Result<Data, Error>,
        using completionHandler: ImageDownloader.CompletionHandler
    ) {
        switch dataResult {
        case .success(let data):
            guard let image = UIImage(data: data) else {
                return completionHandler(.failure(DownloaderError.invalidImageData))
            }
            
            completionHandler(.success(image))
        case .failure(let error):
            handleDataError(error, using: completionHandler)
        }
    }
    
    
    func handleDataError(
        _ error: Error,
        using completionHandler: ImageDownloader.CompletionHandler
    ) {
        switch error {
        case (let nsError as NSError?) where nsError != nil:
            if nsError!.code == NSURLErrorCancelled {
                return
            }
        default:
            completionHandler(.failure(error))
        }
    }
}
