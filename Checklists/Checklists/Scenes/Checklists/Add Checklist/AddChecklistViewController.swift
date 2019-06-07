//
//  AddChecklistViewController.swift
//  Checklists
//
//  Created by Brian Sipple on 6/5/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class AddChecklistViewController: UITableViewController {
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    
    var checklist: Checklist?
    weak var delegate: AddChecklistViewControllerDelegate?
}


// MARK: - Computeds

extension AddChecklistViewController {

    var checklistFromForm: Checklist {
        return Checklist(title: nameTextField.text ?? "", iconName: "", isChecked: false)
    }
    
}


// MARK: - Lifecycle

extension AddChecklistViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameTextField.becomeFirstResponder()
    }
}


// MARK: - Navigation

extension AddChecklistViewController {}


// MARK: - Event Handling

extension AddChecklistViewController {
    
    @IBAction func cancelButtonTapped() {
        delegate?.addChecklistViewControllerDidCancel(self)
    }
    
    
    @IBAction func doneButtonTapped() {
        delegate?.addChecklistViewController(self, didFinishAdding: checklistFromForm)
    }
}


// MARK: - UITableViewDelegate

extension AddChecklistViewController {

}



// MARK: - UITextFieldDelegate

extension AddChecklistViewController: UITextFieldDelegate {
    
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
