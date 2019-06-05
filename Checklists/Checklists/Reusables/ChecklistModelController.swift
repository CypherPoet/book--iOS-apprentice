//
//  ChecklistModelController.swift
//  Checklists
//
//  Created by Brian Sipple on 6/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


final class ChecklistModelController {
    
    enum Error: Swift.Error {
        case noData
    }
}


// MARK: - Core Methods

extension ChecklistModelController {
    
    func loadChecklists(then completionHandler: @escaping (Result<[ChecklistItem], Error>) -> Void) {
        let checklists = [
            ChecklistItem(title: "To Do", iconName: "", isChecked: false),
            ChecklistItem(title: "Trades", iconName: "", isChecked: false),
            ChecklistItem(title: "The Swiftness", iconName: "", isChecked: false)
        ]
        
        completionHandler(.success(checklists))
    }
    
}
