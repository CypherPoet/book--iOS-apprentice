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
    var newChecklistId: Checklist.ID!
    
    weak var delegate: AddEditChecklistViewControllerDelegate?
}


// MARK: - Computeds

extension AddEditChecklistViewController {
    var checklistFromChanges: Checklist {
        var checklist = checklistToEdit ?? Checklist(id: newChecklistId, title: "", iconName: "")

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
        
        assert(checklistToEdit != nil || newChecklistId != nil)
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
        delegate?.addEditChecklistViewControllerDidCancel(self)
    }
    
    
    @IBAction func doneButtonTapped() {
        if checklistToEdit == nil {
            delegate?.addEditChecklistViewController(self, didFinishAdding: checklistFromChanges)
        } else {
            delegate?.addEditChecklistViewController(self, didFinishEditing: checklistFromChanges)
        }
    }
}


// MARK: - UITableViewDelegate

extension AddEditChecklistViewController {

}



// MARK: - UITextFieldDelegate

extension AddEditChecklistViewController: UITextFieldDelegate {
    
    /**
      Invoked every time the user changes the text, whether by tapping on the keyboard or via cut/paste.
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text ?? ""
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneButton.isEnabled = !newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.isEnabled = false
        return true
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
