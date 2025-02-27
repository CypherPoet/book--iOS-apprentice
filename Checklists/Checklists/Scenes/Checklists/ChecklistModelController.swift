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
    
    private var observers: [ChecklistModelControllerObserving] = []

    private(set) var checklists: [Checklist] = [] {
        didSet {
            observers.forEach { $0.checklistModelControllerDidUpdate(self) }
        }
    }

    
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
        return Checklist(title: "My First List")
    }
    
    var checklistsByNameAsc: [Checklist] {
        return checklists.sorted {
            return $0.title.localizedStandardCompare($1.title) == .orderedAscending
        }
    }
}


// MARK: - Core Methods

extension ChecklistModelController {
    typealias LoadCompletionHandler = (Result<Void, Error>) -> Void
    typealias ChecklistUpdateCompletionHandler = (Result<Checklist, Error>) -> Void
    
    typealias ItemUpdateCompletionHandler = (
        Result<(updatedItem: Checklist.Item, updatedChecklist: Checklist), Error>
    ) -> Void
    
    
    func addObserver(_ observer: ChecklistModelControllerObserving) {
        observers.append(observer)
    }
    
    
    func loadChecklists(then completionHandler: LoadCompletionHandler? = nil) {
        if UserDefaults.Keys.isFirstRunOfApp.get(defaultValue: false) {
            UserDefaults.Keys.isFirstRunOfApp.set(false)
            
            setupInitialChecklist()
            completionHandler?(.success( () ))
        } else {
            dataLoader.loadSavedChecklists { [weak self] dataResult in
                switch dataResult {
                case .success(let checklists):
                    self?.checklists = checklists
                    completionHandler?(.success( () ))
                case .failure(.noData):
                    self?.setupInitialChecklist()
                    completionHandler?(.success( () ))
                }
            }
        }
    }
    
    
    func saveChecklistData() {
        dataLoader.save(checklists)
    }
    
    
    func create(
        _ newChecklist: Checklist,
        then completionHandler: ChecklistUpdateCompletionHandler? = nil
    ) {
        checklists.append(newChecklist)
        completionHandler?(.success(newChecklist))
    }
    
    
    func delete(
        _ checklist: Checklist,
        then completionHandler: ChecklistUpdateCompletionHandler? = nil
    ) {
        guard let index = checklists.firstIndex(of: checklist) else {
            preconditionFailure("Unable to find checklist")
        }
        
        let removed = checklists.remove(at: index)
        
        completionHandler?(.success(removed))
    }
}


// MARK: - Private Helpers

private extension ChecklistModelController {
    
    func setupInitialChecklist() {
        checklists.removeAll()
        checklists.append(firstChecklist)
        
        stateController.indexPathOfCurrentChecklist = IndexPath(row: 0, section: 0)
    }
}
