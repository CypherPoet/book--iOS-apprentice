//
//  CoreDataContextHandling.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/9/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


protocol CoreDataContextHandling {
    func fatalCoreDataError(_ error: Error)
}


extension CoreDataContextHandling {
    func fatalCoreDataError(_ error: Error) {
        print("💥 Fatal Core Data Error: \(error)")
        
        NotificationCenter.default.post(
            Notification(name: .CoreDataSaveFailed, object: nil, userInfo: nil)
        )
    }
}
