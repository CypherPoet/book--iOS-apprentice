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
    
    private var checklists: [Checklist] = []
}


// MARK: - Core Methods

extension ChecklistItemsModelController {
    
    func loadChecklists(then completionHandler: @escaping (Result<[Checklist], Error>) -> Void) {
        
        let checklists = [
            Checklist(title: "To Do", iconName: "", isChecked: false),
            Checklist(title: "Trades", iconName: "", isChecked: false),
            Checklist(title: "The Swiftness", iconName: "", isChecked: false)
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
