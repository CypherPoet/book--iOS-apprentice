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
    
    var checklist: ChecklistItem?
}


// MARK: - Computeds

extension AddChecklistViewController {

    var checklistFromForm: ChecklistItem {
        return ChecklistItem(title: nameTextField.text ?? "", iconName: "", isChecked: false)
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

extension AddChecklistViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == R.segue.addChecklistViewController.unwindFromSubmit.identifier else {
            return
        }
        
        checklist = checklistFromForm
    }

}


// MARK: - Event Handling

extension AddChecklistViewController {
    
    /**
     Allow the name text field's "return" button to submit the form
     */
    @IBAction func nameTextFieldReturned(_ sender: UITextField) {
        sender.resignFirstResponder()
        performSegue(withIdentifier: R.segue.addChecklistViewController.unwindFromSubmit.identifier, sender: self)
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
