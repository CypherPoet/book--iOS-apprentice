//
//  BackgroundingHandler.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/15/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

typealias BackgroundingHandler = BackgroundingListening & BackgroundingHandling

protocol BackgroundingListening: class {
    func listenForBackgroundNotification()
}

@objc protocol BackgroundingHandling: class {
    func appDidEnterBackground()
}


extension BackgroundingListening where Self: BackgroundingHandling {
    
    func listenForBackgroundNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }
}
