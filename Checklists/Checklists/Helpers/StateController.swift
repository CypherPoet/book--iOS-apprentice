//
//  StateController.swift
//  Checklists
//
//  Created by Brian Sipple on 6/12/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


final class StateController {
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
