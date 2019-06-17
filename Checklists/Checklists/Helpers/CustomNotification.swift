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
    static let calendar = Calendar(identifier: .gregorian)
    
    case checklistItemReminder(for: Checklist.Item, dueAt: Date)
    
    var request: UNNotificationRequest {
        return UNNotificationRequest(
            identifier: self.identifier,
            content: self.content,
            trigger: self.trigger
        )
    }

    
    var identifier: String {
        switch self {
        case .checklistItemReminder(let item, _):
            return item.notificationID
        }
    }
    
    
    var content: UNNotificationContent {
        let content = UNMutableNotificationContent()

        switch self {
        case .checklistItemReminder(let item, _):
            content.title = "📌 Reminder 📌"
            content.body = item.title
            content.sound = .default            
        }
        
        return content
    }
    

    var trigger: UNNotificationTrigger {
        switch self {
        case .checklistItemReminder(_, let dueDate):
            let dateComponents = CustomNotification.calendar.dateComponents(
                [.year, .month, .hour, .minute],
                from: dueDate
            )
                
            return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        }
    }
}
