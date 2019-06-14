//
//  Checklist+Category.swift
//  Checklists
//
//  Created by Brian Sipple on 6/14/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


extension Checklist {
    enum Category: String, CaseIterable {
        case misc
        case experiments
        case drawing
        
        var iconName: String {
            switch self {
            case .misc:
                return "No Icon"
            case .drawing:
                return "Drawing"
            case .experiments:
                return "Experiments"
            }
        }
    }
}


extension Checklist.Category: Codable {}
