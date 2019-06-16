//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Brian Sipple on 6/7/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation

extension Checklist {
    
    final class Item: NSObject {
        var title: String
        var isChecked: Bool
        var dueDate: Date?
        var shouldRemind: Bool
        
        private(set) var notificationID: String

        
        init(
            title: String,
            isChecked: Bool = false,
            dueDate: Date? = nil,
            shouldRemind: Bool = false,
            notificationID: String? = nil
        ) {
            self.title = title
            self.isChecked = isChecked
            self.dueDate = dueDate
            self.shouldRemind = shouldRemind
            self.notificationID = notificationID ?? "ChecklistItem::\(title)::\(UUID().uuidString)"
        }
    }
}

extension Checklist.Item: Codable {}
