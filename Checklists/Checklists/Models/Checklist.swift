//
//  Checklist.swift
//  Checklists
//
//  Created by Brian Sipple on 6/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation

final class Checklist: NSObject {
    var title: String
    var iconName: String
    var items: [Item] = []


    init(title: String, iconName: String) {
        self.title = title
        self.iconName = iconName
        self.items = [Item]()
    }
}


extension Checklist: Codable {}
