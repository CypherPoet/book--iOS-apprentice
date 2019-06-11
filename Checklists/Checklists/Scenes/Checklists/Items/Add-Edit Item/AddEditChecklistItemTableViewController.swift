//
//  AddEditChecklistItemTableViewController.swift
//  Checklists
//
//  Created by Brian Sipple on 6/10/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class AddEditChecklistItemTableViewController: UITableViewController {
    @IBOutlet private weak var itemTextField: UITextField!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    
    var itemToEdit: Checklist.Item?
    
    weak var delegate: ChecklistItemFormViewControllerDelegate?
    lazy var itemTextFieldHandler = BarItemTogglingTextFieldHandler(barItem: doneButton)
}



// MARK: - Computeds

extension AddEditChecklistItemTableViewController {

    var checklistItemFromChanges: Checklist.Item {
        let item = itemToEdit ?? Checklist.Item(title: "")
        
        item.title = itemTextField.text!
        
        return item
    }
    
    
    var viewTitle: String {
        return itemToEdit != nil ? "Edit Item" : "Add Item"
    }
}


// MARK: - Lifecycle

extension AddEditChecklistItemTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTextField.delegate = itemTextFieldHandler
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        itemTextField.becomeFirstResponder()
    }
}


// MARK: - Event Handling

extension AddEditChecklistItemTableViewController {
    
    @IBAction func cancelButtonTapped() {
        delegate?.checklistItemFormViewControllerDidCancel(self)
    }
    
    
    @IBAction func doneButtonTapped() {
        if itemToEdit == nil {
            delegate?.checklistItemFormViewController(self, didFinishAdding: checklistItemFromChanges)
        } else {
            delegate?.checklistItemFormViewController(self, didFinishEditing: checklistItemFromChanges)
        }
    }
}



// MARK: - Private Helpers

private extension AddEditChecklistItemTableViewController {
    
    func setupUI() {
        title = viewTitle
        
        if let itemToEdit = itemToEdit {
            itemTextField.text = itemToEdit.title
            doneButton.isEnabled = true
        }
    }
}
