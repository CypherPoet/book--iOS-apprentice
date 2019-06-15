//
//  IconPickerViewControllerDelegate.swift
//  Checklists
//
//  Created by Brian Sipple on 6/14/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

protocol ChecklistCategoryPickerViewControllerDelegate: class {
    func checklistCategoryPickerViewController(_ controller: UIViewController, didPick category: Checklist.Category)
}
