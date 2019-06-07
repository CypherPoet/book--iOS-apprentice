//
//  AddChecklistViewControllerDelegate.swift
//  Checklists
//
//  Created by Brian Sipple on 6/6/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


protocol AddChecklistViewControllerDelegate: class {
    func addChecklistViewControllerDidCancel(_ viewController: AddChecklistViewController)

    func addChecklistViewController(_ viewController: AddChecklistViewController, didFinishAdding newChecklist: Checklist)
}
