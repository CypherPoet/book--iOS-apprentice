//
//  ChecklistItemViewControllerDelegate.swift
//  Checklists
//
//  Created by Brian Sipple on 6/10/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

protocol ChecklistItemViewControllerDelegate: class {

    func checklistItemViewController(
        _ controller: UIViewController,
        didFinishUpdating checklistItem: Checklist.Item,
        in checklist: Checklist
    )
    
    
    func checklistItemViewController(
        _ controller: UIViewController,
        didFinishAdding checklistItem: Checklist.Item,
        in checklist: Checklist
    )
}
