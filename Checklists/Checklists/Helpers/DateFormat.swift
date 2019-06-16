//
//  DateFormatter.swift
//  Checklists
//
//  Created by Brian Sipple on 6/16/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


enum DateFormat {
    
    static func listItemDueDate(from date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
}
