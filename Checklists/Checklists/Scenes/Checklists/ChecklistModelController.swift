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
    
    private(set) var checklists: [Checklist] = []

    init(dataLoader: ChecklistLoader = ChecklistLoader()) {
        self.dataLoader = dataLoader
    }
}


// MARK: - Computeds

extension ChecklistModelController {
    
    /// Used to load the app on the view of a checklist if that's what it previously exited on
    var indexPathOfCurrentChecklist: IndexPath? {
        get {
            if
                let row = UserDefaults.Keys.currentChecklistIndexPathRow.get(),
                let section = UserDefaults.Keys.currentChecklistIndexPathSection.get()
            {
                return IndexPath(row: row, section: section)
            } else {
                return nil
            }
        }
        
        set {
            if let newValue = newValue {
                UserDefaults.Keys.currentChecklistIndexPathRow.set(newValue.row)
                UserDefaults.Keys.currentChecklistIndexPathSection.set(newValue.section)
            } else {
                UserDefaults.Keys.currentChecklistIndexPathRow.removeValue()
                UserDefaults.Keys.currentChecklistIndexPathSection.removeValue()
            }
        }
    }
    
}


// MARK: - Core Methods

extension ChecklistModelController {
    typealias ChecklistUpdateCompletionHandler = (Result<Checklist, Error>) -> Void
    
    typealias ItemUpdateCompletionHandler = (
        Result<(updatedItem: Checklist.Item, updatedChecklist: Checklist), Error>
    ) -> Void
    
    
    func loadSavedChecklists() {
        dataLoader.loadSavedChecklists { [weak self] dataResult in            
            switch dataResult {
            case .success(let checklists):
                self?.checklists = checklists
            case .failure(.noData):
                self?.checklists = []
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
