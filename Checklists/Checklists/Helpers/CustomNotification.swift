//
//  CustomNotificationRequest.swift
//  Checklists
//
//  Created by Brian Sipple on 6/15/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation
import UserNotifications


enum CustomNotification {
    case sample
    
    
    var request: UNNotificationRequest {
        switch self {
        case .sample:
            return UNNotificationRequest(
                identifier: "sample",
                content: self.content,
                trigger: self.trigger
            )
        }
    }
    
    
    var content: UNNotificationContent {
        let content = UNMutableNotificationContent()

        switch self {
        case .sample:
            content.title = "Hello!"
            content.body = "This is a test notification."
            content.sound = .default
        }
        
        return content
    }
    

    var trigger: UNNotificationTrigger {
        switch self {
        case .sample:
            return UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        }
    }
}

