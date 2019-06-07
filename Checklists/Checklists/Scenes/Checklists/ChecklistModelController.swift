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
    
    private var checklists: [Checklist] = []
}


// MARK: - Core Methods

extension ChecklistModelController {
    
    func loadChecklists(then completionHandler: @escaping (Result<[Checklist], Error>) -> Void) {
        let dummyItems = [
            ChecklistItem(title: "Item 1", isChecked: false),
            ChecklistItem(title: "Item 2", isChecked: false),
            ChecklistItem(title: "Item 3", isChecked: false),
        ]
        
        let checklists = [
            Checklist(title: "To Do", iconName: "", items: dummyItems),
            Checklist(title: "Trades", iconName: "", items: dummyItems),
            Checklist(title: "The Swiftness", iconName: "", items: dummyItems)
        ]
        
        self.checklists = checklists
        completionHandler(.success(checklists))
    }
    
    
    func add(_ newChecklist: Checklist, at index: Int, then completionHandler: @escaping (Result<Checklist, Error>) -> Void) {
        checklists.append(newChecklist)
        
        completionHandler(.success(newChecklist))
    }
    
    
    func removeChecklist(at index: Int, then completionHandler: @escaping (Result<Void, Error>) -> Void) {
        checklists.remove(at: index)
        
        completionHandler(.success(()))
    }
    
}
