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
    @IBOutlet private var remindMeSwitch: UISwitch!
    @IBOutlet private var dueDateLabel: UILabel!
    @IBOutlet private var doneButton: UIBarButtonItem!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var clearDueDateButton: UIButton!
    
    var itemToEdit: Checklist.Item?
    
    var selectedDueDate: Date? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.selectedDueDateChanged()
            }
        }
    }
    
    let dueDateIndexPath = IndexPath(row: 1, section: 1)
    let dueDatePickerIndexPath = IndexPath(row: 2, section: 1)
    let visibleDatePickerHeight = CGFloat(217)
    
    var isDatePickerVisible = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.dueDatePickerVisibilityChanged()
            }
        }
    }
    
    weak var delegate: ChecklistItemFormViewControllerDelegate?
    
    lazy var nameTextFieldHandler = EmptyTextFieldChecker(
        changeHandler: { [weak self] isNameTextEmpty in
            self?.doneButton.isEnabled = !isNameTextEmpty
        }
    )
}



// MARK: - Computeds

extension AddEditChecklistItemTableViewController {

    var viewTitle: String {
        return itemToEdit == nil ? "Add Item" : "Edit Item"
    }
    
    var minimumDueDate: Date {
        return Date().addingTimeInterval(60 * 2)
    }
}


// MARK: - Lifecycle

extension AddEditChecklistItemTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func dueDateChanged(_ picker: UIDatePicker) {
        selectedDueDate = picker.date
    }
    
    @IBAction func titleTextBeganEditing() {
        isDatePickerVisible = false
    }
    
    @IBAction func clearDueDateTapped(_ sender: UIButton) {
        selectedDueDate = nil
    }
    
    
    @IBAction func cancelButtonTapped() {
        delegate?.checklistItemFormViewControllerDidCancel(self)
    }
    
    
    @IBAction func doneButtonTapped() {
        submitItemFromChanges()
    }
}


// MARK: - UITableViewDelegate

extension AddEditChecklistItemTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row, indexPath.section) {
        case (dueDatePickerIndexPath.row, dueDatePickerIndexPath.section):
            return isDatePickerVisible ? visibleDatePickerHeight : 0.0
        default:
            return UITableView.automaticDimension
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (indexPath.row, indexPath.section) == (dueDateIndexPath.row, dueDateIndexPath.section) {
            return indexPath
        } else {
            return nil
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row, indexPath.section) == (dueDateIndexPath.row, dueDateIndexPath.section) {
            titleTextField.resignFirstResponder()
            isDatePickerVisible.toggle()
        }
    }
}


// MARK: - Private Helpers

private extension AddEditChecklistItemTableViewController {
    
    func setupUI(with item: Checklist.Item?) {
        titleTextField.text = item?.title
        remindMeSwitch.isOn = item?.shouldRemind ?? false
        
        clearDueDateButton.alpha = item?.dueDate != nil ? 1.0 : 0.0
        selectedDueDate = item?.dueDate
        
        let minimumDueDate = self.minimumDueDate
        dueDatePicker.setDate(item?.dueDate ?? minimumDueDate, animated: false)
        dueDatePicker.minimumDate = minimumDueDate
        
        titleTextField.delegate = nameTextFieldHandler
        nameTextFieldHandler.isEmpty = !titleTextField.hasText
    }
    
    
    func submitItemFromChanges() {
        guard let title = titleTextField.text else {
            preconditionFailure("Incomplete data")
        }
        
        let shouldRemind = remindMeSwitch.isOn
        
        if let itemToEdit = itemToEdit {
            itemToEdit.title = title
            itemToEdit.dueDate = selectedDueDate
            itemToEdit.shouldRemind = shouldRemind
            
            delegate?.checklistItemFormViewController(self, didFinishEditing: itemToEdit)
        } else {
            let newItem = Checklist.Item(
                title: title,
                dueDate: selectedDueDate,
                shouldRemind: shouldRemind
            )
            
            delegate?.checklistItemFormViewController(self, didFinishAdding: newItem)
        }
    }
    
    
    func toggleDatePickerVisibility() {
        if isDatePickerVisible {
            tableView.insertRows(at: [dueDatePickerIndexPath], with: .fade)
        } else {
            tableView.deleteRows(at: [dueDatePickerIndexPath], with: .fade)
        }
    }
    
    
    func selectedDueDateChanged() {
        if let dueDate = selectedDueDate {
            UIView.animate(
                withDuration: 0.2,
                animations: {
                    self.clearDueDateButton.alpha = 1
                }
            )
            dueDateLabel.text = DateFormat.listItemDueDate(from: dueDate)
            
        } else {
            UIView.animate(
                withDuration: 0.2,
                animations: {
                    self.clearDueDateButton.alpha = 0.0
                }
            )
            dueDateLabel.text = "Whenever ✌️"
        }
    }
    
    
    func dueDatePickerVisibilityChanged() {
        tableView.beginUpdates()
        dueDatePicker.isHidden = !isDatePickerVisible
        tableView.endUpdates()
        
        let dueDateLabelColor = isDatePickerVisible ? #colorLiteral(red: 0.4660422802, green: 0.4231178463, blue: 0.8790649772, alpha: 1) : UIColor.darkText
        
        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.dueDateLabel.textColor = dueDateLabelColor
            }
        )
    }
}
