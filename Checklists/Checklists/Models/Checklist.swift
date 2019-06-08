//
//  Checklist.swift
//  Checklists
//
//  Created by Brian Sipple on 6/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation

struct Checklist: Identifiable {
    typealias ID = String
    typealias IdentifiedValue = Checklist

    var id: ID
    var title: String
    var iconName: String
    var items: [ChecklistItem] = []
}



extension Checklist {
    init(id: ID, title: String, iconName: String) {
        self.id = id
        self.title = title
        self.iconName = iconName
        self.items = [ChecklistItem]()
    }
}
