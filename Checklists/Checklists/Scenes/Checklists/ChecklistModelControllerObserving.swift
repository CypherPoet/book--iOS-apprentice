//
//  ChecklistModelControllerObserving.swift
//  Checklists
//
//  Created by Brian Sipple on 6/13/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//


import Foundation


protocol ChecklistModelControllerObserving: class {
    func checklistModelControllerDidUpdate(_ controller: ChecklistModelController)
}
