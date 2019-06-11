//
//  AddEditChecklistViewController.swift
//  Checklists
//
//  Created by Brian Sipple on 6/5/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class AddEditChecklistViewController: UITableViewController {
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    
    var checklistToEdit: Checklist?
    
    weak var delegate: ChecklistFormViewControllerDelegate?
    lazy var nameTextFieldHandler = BarItemTogglingTextFieldHandler(barItem: doneButton)
}


// MARK: - Computeds

extension AddEditChecklistViewController {
    var checklistFromChanges: Checklist {
        let checklist = checklistToEdit ?? Checklist(title: "", iconName: "")

        checklist.title = nameTextField.text!
        
        return checklist
    }

    
    var viewTitle: String {
        return checklistToEdit != nil ? "Edit Checklist" : "Add Checklist"
    }
}


// MARK: - Lifecycle

extension AddEditChecklistViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = nameTextFieldHandler
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameTextField.becomeFirstResponder()
    }
}


// MARK: - Event Handling

extension AddEditChecklistViewController {
    
    @IBAction func cancelButtonTapped() {
        delegate?.checklistFormViewControllerDidCancel(self)
    }
    
    
    @IBAction func doneButtonTapped() {
        if checklistToEdit == nil {
            delegate?.checklistFormViewController(self, didFinishAdding: checklistFromChanges)
        } else {
            delegate?.checklistFormViewController(self, didFinishEditing: checklistFromChanges)
        }
    }
}


// MARK: - Private Helpers

private extension AddEditChecklistViewController {
    
    func setupUI() {
        title = viewTitle

        if let checklistToEdit = checklistToEdit {
            nameTextField.text = checklistToEdit.title
            doneButton.isEnabled = true
        }
    }
}
