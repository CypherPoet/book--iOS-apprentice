//
//  ChecklistItemFormViewControllerDelegate.swift
//  Checklists
//
//  Created by Brian Sipple on 6/11/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

protocol ChecklistItemFormViewControllerDelegate: class {
    func checklistItemFormViewController(_ viewController: UIViewController, didFinishAdding newItem: Checklist.Item)
    func checklistItemFormViewController(_ viewController: UIViewController, didFinishEditing item: Checklist.Item)
    
    func checklistItemFormViewControllerDidCancel(_ viewController: UIViewController)
}
