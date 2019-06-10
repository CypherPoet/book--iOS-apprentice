//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Brian Sipple on 6/7/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation

extension Checklist {
    typealias ItemId = String
    
    struct Item: Identifiable {
        var id: ItemId
        var title: String
        var isChecked: Bool
    }
}


extension Checklist.Item {
    init(id: Checklist.ItemId, title: String) {
        self.id = id
        self.title = title
        self.isChecked = false
    }
}


extension Checklist.Item: Codable {}
