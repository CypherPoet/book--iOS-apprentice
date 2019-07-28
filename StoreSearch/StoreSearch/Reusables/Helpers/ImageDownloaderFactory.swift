//
//  ImageLoaderFactory.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

final class ImageDownloaderFactory {
    private let transport: DownloadingTransport
    private let queue: DispatchQueue
    
    
    init(
        transport: DownloadingTransport = URLSession.shared,
        queue: DispatchQueue = .global(qos: .userInitiated)
    ) {
        self.transport = transport
        self.queue = queue
    }
    
    
    func makeDownloader() -> ImageDownloader {
        return SessionImageDownloader(transport: transport, queue: queue)
    }
}
