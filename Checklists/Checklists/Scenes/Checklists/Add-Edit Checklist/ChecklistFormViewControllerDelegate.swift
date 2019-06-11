//
//  AddEditChecklistViewControllerDelegate.swift
//  Checklists
//
//  Created by Brian Sipple on 6/6/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


protocol ChecklistFormViewControllerDelegate: class {
    func checklistFormViewController(_ viewController: UIViewController, didFinishAdding newChecklist: Checklist)
    func checklistFormViewController(_ viewController: UIViewController, didFinishEditing checklist: Checklist)

    func checklistFormViewControllerDidCancel(_ viewController: UIViewController)
}
