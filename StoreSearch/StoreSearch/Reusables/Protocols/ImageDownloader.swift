//
//  ImageDownloader.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

protocol ImageDownloader {
    typealias CompletionHandler = (Result<UIImage, Error>) -> Void
    
    func downloadImage(
        from url: URL,
        then completionHandler: @escaping CompletionHandler
    ) -> DownloadTaskToken
}
