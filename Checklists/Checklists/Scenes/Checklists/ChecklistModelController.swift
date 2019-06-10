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


// MARK: - Error Type

extension ChecklistModelController {
    enum Error: Swift.Error {
        case noData(message: String)
        case invalidAccess(_ message: String)
    }
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
    
    
    func loadSavedChecklists() {
        dataLoader.loadSavedChecklists { [weak self] dataResult in
            switch dataResult {
            case .success(let checklists):
                self?.checklists = checklists
            case .failure(let error):
                fatalError(
                    "Error while attempting to load saved checklists:\n\n\(error.localizedDescription)"
                )
            }
        }
    }
    
    
    func saveChecklists() {
        dataLoader.save(checklists)
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


private extension ChecklistModelController {
    
    func makeDummyChecklists() -> [Checklist] {
        let dummyItems: [Checklist.Item] = [
            .init(id: "1", title: "Item 1", isChecked: false),
            .init(id: "2", title: "Item 2", isChecked: false),
            .init(id: "3", title: "Item 3", isChecked: false),
        ]
        
        return [
            Checklist(id: "1", title: "Swift Magic", iconName: "", items: dummyItems),
            Checklist(id: "2", title: "Trades", iconName: "", items: dummyItems),
            Checklist(id: "3", title: "The Swiftness", iconName: "", items: dummyItems)
        ]
    }
}
