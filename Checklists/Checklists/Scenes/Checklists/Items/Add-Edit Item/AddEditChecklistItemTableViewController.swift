//
//  AddEditChecklistItemTableViewController.swift
//  Checklists
//
//  Created by Brian Sipple on 6/10/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class AddEditChecklistItemTableViewController: UITableViewController {
    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var doneButton: UIBarButtonItem!

    var itemToEdit: Checklist.Item?
    
    weak var delegate: ChecklistItemFormViewControllerDelegate?
    
    lazy var titleTextFieldHandler = EmptyTextFieldChecker(
        isEmpty: titleTextField.hasText,
        changeHandler: { [weak self] isTitleTextEmpty in
            self?.doneButton.isEnabled = isTitleTextEmpty
        }
    )
}



// MARK: - Computeds

extension AddEditChecklistItemTableViewController {

    var checklistItemFromChanges: Checklist.Item {
        let item = itemToEdit ?? Checklist.Item(title: "")
        
        item.title = titleTextField.text!
        
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
        
        titleTextField.delegate = titleTextFieldHandler
        title = viewTitle
        
        setupUI(with: itemToEdit)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleTextField.becomeFirstResponder()
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
    
    func setupUI(with itemToEdit: Checklist.Item?) {
        doneButton.isEnabled = itemToEdit != nil
        titleTextField.text = itemToEdit?.title
    }
}
