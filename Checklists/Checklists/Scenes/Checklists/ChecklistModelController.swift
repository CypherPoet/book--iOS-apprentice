//
//  ChecklistModelController.swift
//  Checklists
//
//  Created by Brian Sipple on 6/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


final class ChecklistModelController {
    private var dataLoader: ChecklistLoader
    private var stateController: StateController
    
    private(set) var checklists: [Checklist] = []

    
    init(
        dataLoader: ChecklistLoader = ChecklistLoader(),
        stateController: StateController = StateController()
    ) {
        self.dataLoader = dataLoader
        self.stateController = stateController
    }
}


// MARK: - Computeds

extension ChecklistModelController {
    var firstChecklist: Checklist {
        return Checklist(title: "My First List", iconName: "")
    }
}


// MARK: - Core Methods

extension ChecklistModelController {
    typealias ChecklistsCompletionHandler = (Result<[Checklist], Error>) -> Void
    typealias ChecklistUpdateCompletionHandler = (Result<Checklist, Error>) -> Void
    
    typealias ItemUpdateCompletionHandler = (
        Result<(updatedItem: Checklist.Item, updatedChecklist: Checklist), Error>
    ) -> Void
    
    
    func loadChecklists(then completionHandler: @escaping ChecklistsCompletionHandler) {
        if UserDefaults.Keys.isFirstRunOfApp.get(defaultValue: false) {
            UserDefaults.Keys.isFirstRunOfApp.set(false)
            
            checklists.append(firstChecklist)
            stateController.indexPathOfCurrentChecklist = IndexPath(row: 0, section: 0)
            
            completionHandler(.success(checklists))
        } else {
            dataLoader.loadSavedChecklists { [weak self] dataResult in
                switch dataResult {
                case .success(let checklists):
                    self?.checklists = checklists
                    completionHandler(.success(checklists))
                case .failure(.noData):
                    self?.checklists = []
                    completionHandler(.success([]))
                }
            }
        }
    }
    
    func saveChecklistData() {
        dataLoader.save(checklists)
    }
    
    
    func create(
        _ newChecklist: Checklist,
        then completionHandler: @escaping ChecklistUpdateCompletionHandler
    ) {
        checklists.append(newChecklist)
        completionHandler(.success(newChecklist))
    }
    
    
    func removeChecklist(at index: Int, then completionHandler: ChecklistUpdateCompletionHandler) {
        let removed = checklists.remove(at: index)
        
        completionHandler(.success(removed))
    }
}
