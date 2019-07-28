//
//  DownloadingTransport.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


protocol DownloadingTransport {

    func makeTask(
        for request: URLRequest,
        then completionHandler: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDownloadTask
}
