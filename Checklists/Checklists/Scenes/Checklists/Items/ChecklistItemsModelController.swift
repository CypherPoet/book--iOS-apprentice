//
//  ChecklistItemsModelController.swift
//  Checklists
//
//  Created by Brian Sipple on 6/6/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

final class ChecklistItemsModelController {
    private var checklist: Checklist

    init(checklist: Checklist) {
        self.checklist = checklist
    }
}



// MARK: - Computeds

extension ChecklistItemsModelController {
    
    var checklistItems: [ChecklistItem] {
        return checklist.items
    }
}
