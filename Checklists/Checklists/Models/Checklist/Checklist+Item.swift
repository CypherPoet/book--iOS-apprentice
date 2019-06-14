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

        init(title: String) {
            self.title = title
            self.isChecked = false
        }
    }
}

extension Checklist.Item: Codable {}
