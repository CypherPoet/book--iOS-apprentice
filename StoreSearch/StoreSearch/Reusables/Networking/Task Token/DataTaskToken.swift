//
//  RequestToken.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/26/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


final class DataTaskToken: TaskToken {
    private weak var task: URLSessionDataTask?

    init(task: URLSessionDataTask) {
        self.task = task
    }

    
    func resume() {
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    var taskURL: URL? { task?.currentRequest?.url }
}
