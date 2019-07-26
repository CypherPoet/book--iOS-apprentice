//
//  TaskToken.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/26/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


/// Allows for initialization of an object that abstracts
/// a cancellable task from the task itself by providing a `cancel` handler.
///
/// This can be useful for cancellable `URLSession` data tasks.
/// 
/// Kudos to https://www.swiftbysundell.com/posts/using-tokens-to-handle-async-swift-code
/// for the inspiration.
protocol TaskToken: class {
    associatedtype Task
    
    init(task: Task)
    
    func cancel()
}
