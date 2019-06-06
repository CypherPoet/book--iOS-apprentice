//
//  ChecklistModelController.swift
//  Checklists
//
//  Created by Brian Sipple on 6/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


final class ChecklistItemsModelController {
    
    enum Error: Swift.Error {
        case noData
    }
    
    private var checklists: [ChecklistItem] = []
}


// MARK: - Core Methods

extension ChecklistItemsModelController {
    
    func loadChecklists(then completionHandler: @escaping (Result<[ChecklistItem], Error>) -> Void) {
        
        let checklists = [
            ChecklistItem(title: "To Do", iconName: "", isChecked: false),
            ChecklistItem(title: "Trades", iconName: "", isChecked: false),
            ChecklistItem(title: "The Swiftness", iconName: "", isChecked: false)
        ]
        
        self.checklists = checklists
        completionHandler(.success(checklists))
    }
    
    
    func createNewItem(then completionHandler: @escaping (Result<ChecklistItem, Error>) -> Void) {
        
        let newChecklist = ChecklistItem(title: "New Checklist", iconName: "", isChecked: false)
        
        checklists.append(newChecklist)
        
        completionHandler(.success(newChecklist))
    }
    
    
    func removeItem(at index: Int, then completionHandler: @escaping (Result<Void, Error>) -> Void) {
        checklists.remove(at: index)
        
        completionHandler(.success(()))
    }
    
}
