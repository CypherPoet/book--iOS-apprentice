//
//  RequestToken.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/26/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


final class DataTaskToken: TaskToken {
    private weak var task: URLSessionTask?

    init(task: URLSessionTask) {
        self.task = task
    }

    func cancel() {
        task?.cancel()
    }
}
