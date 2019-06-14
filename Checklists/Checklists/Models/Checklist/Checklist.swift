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
    var category: Checklist.Category
    var items: [Item]
    
    
    init(
        title: String,
        category: Checklist.Category = .misc,
        items: [Item] = []
    ) {
        self.title = title
        self.category = category
        self.items = items
    }
}


// MARK: - Codable

extension Checklist: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case category
        case items
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: .title)
        let category = try container.decode(Checklist.Category.self, forKey: .category)
        let items = try container.decode([Checklist.Item].self, forKey: .items)
        
        self.init(title: title, category: category, items: items)
    }
 
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(title, forKey: .title)
        try container.encode(category, forKey: .category)
        try container.encode(items, forKey: .items)
    }
}



// MARK: - Core Methods and Computeds

extension Checklist {
    
    var uncheckedCount: Int {
        return items.reduce(0) { (totalCount, item) -> Int in
            return item.isChecked ? totalCount : totalCount + 1
        }
    }
}
