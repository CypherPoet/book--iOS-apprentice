//
//  AddEditChecklistViewControllerDelegate.swift
//  Checklists
//
//  Created by Brian Sipple on 6/6/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


protocol AddEditChecklistViewControllerDelegate: class {
    func addEditChecklistViewControllerDidCancel(_ viewController: AddEditChecklistViewController)

    func addEditChecklistViewController(_ viewController: AddEditChecklistViewController, didFinishAdding newChecklist: Checklist)
    func addEditChecklistViewController(_ viewController: AddEditChecklistViewController, didFinishEditing checklist: Checklist)
}
