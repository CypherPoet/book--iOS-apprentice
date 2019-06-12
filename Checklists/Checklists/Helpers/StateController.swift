//
//  StateController.swift
//  Checklists
//
//  Created by Brian Sipple on 6/12/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


final class StateController {
    static var defaultDefaults = [
        UserDefaults.Keys.isFirstRunOfApp.keyName: true
    ]
    
    init(initialUserDefaults: [String: Any] = defaultDefaults) {
        setupUserDefaults(with: initialUserDefaults)
    }
}


// MARK: - Computeds

extension StateController {
    
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


// MARK: - Private Helpers

private extension StateController {
    
    func setupUserDefaults(with initialUserDefaults: [String: Any]) {
        UserDefaults.standard.register(defaults: initialUserDefaults)
    }
}
