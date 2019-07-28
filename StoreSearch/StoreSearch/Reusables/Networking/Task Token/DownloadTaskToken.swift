//
//  DownloadTaskToken.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


final class DownloadTaskToken: TaskToken {
    private weak var task: URLSessionDownloadTask?

    init(task: URLSessionDownloadTask) {
        self.task = task
    }
    
    
    func resume() {
        task?.resume()
    }

    
    func cancel() {
        task?.cancel()
    }
}
