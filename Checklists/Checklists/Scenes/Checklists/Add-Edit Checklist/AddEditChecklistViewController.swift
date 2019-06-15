//
//  AddEditChecklistViewController.swift
//  Checklists
//
//  Created by Brian Sipple on 6/5/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class AddEditChecklistViewController: UITableViewController {
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var doneButton: UIBarButtonItem!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var categoryIconImageView: UIImageView!
    
    var checklistToEdit: Checklist?
    
    var selectedChecklistCategory: Checklist.Category? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.categoryLabel.text = self.selectedChecklistCategory?.title ?? "Select a Category"
                self.categoryIconImageView.image = self.selectedChecklistCategory?.iconImage
            }
        }
    }
    
    weak var delegate: ChecklistFormViewControllerDelegate?
    
    lazy var titleTextFieldChecker = EmptyTextFieldChecker(
        changeHandler: { [weak self] isTitleTextEmpty in
            guard let self = self else { return }

            self.doneButton.isEnabled = (
                !isTitleTextEmpty &&
                self.selectedChecklistCategory != nil
            )
        }
    )
}


// MARK: - Computeds

extension AddEditChecklistViewController {
    
    var viewTitle: String {
        return checklistToEdit == nil ? "Add Checklist" : "Edit Checklist"
    }
}


// MARK: - Lifecycle

extension AddEditChecklistViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewTitle
        titleTextField.text = checklistToEdit?.title
        selectedChecklistCategory = checklistToEdit?.category
        
        titleTextField.delegate = titleTextFieldChecker
        titleTextFieldChecker.isEmpty = !titleTextField.hasText
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleTextField.becomeFirstResponder()
    }
}


// MARK: - Navigation

extension AddEditChecklistViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == R.segue.addEditChecklistViewController.showCategoryPicker.identifier,
            let pickerVC = segue.destination as? ChecklistCategoryPickerViewController
        else {
            preconditionFailure("Unknwown Segue")
        }
        
        pickerVC.availableCategories = Checklist.Category.allCases
        pickerVC.delegate = self
    }
}



// MARK: - Event Handling

extension AddEditChecklistViewController {
    
    @IBAction func cancelButtonTapped() {
        delegate?.checklistFormViewControllerDidCancel(self)
    }
    
    
    @IBAction func doneButtonTapped() {
        submitChecklistFromChanges()
    }
}


// MARK: - ChecklistCategoryPickerViewControllerDelegate

extension AddEditChecklistViewController: ChecklistCategoryPickerViewControllerDelegate {
    
    func checklistCategoryPickerViewController(
        _ controller: UIViewController,
        didPick category: Checklist.Category
    ) {
        selectedChecklistCategory = category
        navigationController?.popViewController(animated: true)
    }
}


// MARK: - Private Helpers

private extension AddEditChecklistViewController {
    
    func submitChecklistFromChanges() {
        guard
            let category = selectedChecklistCategory,
            let title = titleTextField.text
        else {
            preconditionFailure("Incomplete data for creating checklist")
        }
        
        if let checklistToEdit = checklistToEdit {
            checklistToEdit.title = title
            checklistToEdit.category = category
            
            delegate?.checklistFormViewController(self, didFinishEditing: checklistToEdit)
        } else {
            let newChecklist = Checklist(title: title, category: category)
            
            delegate?.checklistFormViewController(self, didFinishAdding: newChecklist)
        }
    }
}
