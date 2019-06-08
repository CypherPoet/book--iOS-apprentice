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
        case noData(message: String)
        case invalidAccess(_ message: String)
    }
    
    private var checklists: [Checklist] = []
}


// MARK: - Computeds

extension ChecklistModelController {
    
    var nextId: Checklist.ID {
        return .init(checklists.count + 1)
    }
    
}


// MARK: - Core Methods

extension ChecklistModelController {
    typealias UpdateCompletionHandler = (Result<(Checklist, index: Int), Error>) -> Void
    
    func loadChecklists(then completionHandler: @escaping (Result<[Checklist], Error>) -> Void) {
        let dummyItems = [
            ChecklistItem(title: "Item 1", isChecked: false),
            ChecklistItem(title: "Item 2", isChecked: false),
            ChecklistItem(title: "Item 3", isChecked: false),
        ]
        
        let checklists = [
            Checklist(id: "1", title: "Swift Magic", iconName: "", items: dummyItems),
            Checklist(id: "2", title: "Trades", iconName: "", items: dummyItems),
            Checklist(id: "3", title: "The Swiftness", iconName: "", items: dummyItems)
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
    
    
    func update(
        _ checklist: Checklist,
        then completionHandler: @escaping UpdateCompletionHandler
    ) {
        guard let index = checklists.firstIndex(where: { $0.id == checklist.id }) else {
            return completionHandler(.failure(.invalidAccess("Invalid index")))
        }
        
        checklists[index] = checklist
        completionHandler(.success((checklist, index)))
    }
    
}
