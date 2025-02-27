//
//  ChecklistItemListViewController.swift
//  Checklists
//
//  Created by Brian Sipple on 6/6/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import UserNotifications


class ChecklistItemListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var checklist: Checklist!
    var modelController: ChecklistModelController!
    var dataSource: TableViewDataSource<Checklist.Item>!
}


// MARK: - Computeds

extension ChecklistItemListViewController {
    var checklistItems: [Checklist.Item] {
        return checklist.items
    }
}


// MARK: - Lifecycle

extension ChecklistItemListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(checklist != nil, "No checklist was set")
        assert(modelController != nil, "No model controller was set")
        
        title = checklist.title
        render(with: checklistItems)
    }
    
}


// MARK: - Navigation

extension ChecklistItemListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addEditVC = segue.destination as? AddEditChecklistItemTableViewController else {
            return
        }
        
        if segue.identifier == R.segue.checklistItemListViewController.editChecklistItem.identifier {
            guard let selectedItem = sender as? Checklist.Item else { fatalError() }

            addEditVC.itemToEdit = selectedItem
        }

        addEditVC.delegate = self
    }
    
}


// MARK: - UITableViewDelegate

extension ChecklistItemListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklistItem = dataSource.models[indexPath.row]
        
        checklistItem.isChecked.toggle()
        tableView.deselectRow(at: indexPath, animated: true)
        
        itemUpdated(checklistItem)
    }
    
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let selectedItem = dataSource.models[indexPath.row]
        
        performSegue(withIdentifier: R.segue.checklistItemListViewController.editChecklistItem.identifier, sender: selectedItem)
    }
}


extension ChecklistItemListViewController: ChecklistItemFormViewControllerDelegate {
    
    func checklistItemFormViewController(_ viewController: UIViewController, didFinishAdding newItem: Checklist.Item) {
        navigationController?.popViewController(animated: true)

        checklist.items.append(newItem)
        dataSource.models.append(newItem)
        
        if newItem.reminderState == .needsScheduling {
            newItem.scheduleReminder()
        }
        
        let newIndexPath = IndexPath(row: dataSource.models.count - 1, section: 0)
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    

    func checklistItemFormViewController(_ viewController: UIViewController, didFinishEditing item: Checklist.Item) {
        navigationController?.popViewController(animated: true)
        itemUpdated(item)
    }

    
    func checklistItemFormViewControllerDidCancel(_ viewController: UIViewController) {
        navigationController?.popViewController(animated: true)
    }
}



// MARK: - Private Helpers

private extension ChecklistItemListViewController {
    
    func render(with checklistItems: [Checklist.Item]) {
        let cellReuseId = R.reuseIdentifier.checklistItemTableCell.identifier
        
        let dataSource = TableViewDataSource(
            models: checklistItems,
            cellReuseIdentifier: cellReuseId,
            cellConfigurator: { [weak self] (checklistItem, cell) in
                self?.configure(cell, with: checklistItem)
            },
            cellDeletionHandler: { [weak self] (_, _, indexPath) in
                self?.cellDeleted(at: indexPath)
            }
        )
        
        self.dataSource = dataSource
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        let cellNib = ChecklistItemTableViewCell.nib
        tableView.register(cellNib, forCellReuseIdentifier: cellReuseId)
    }
    
    
    func configure(_ cell: UITableViewCell, with checklistItem: Checklist.Item) {
        guard let cell = cell as? ChecklistItemTableViewCell else { fatalError() }
        
        cell.viewModel = ChecklistItemTableViewCell.ViewModel(
            isChecked: checklistItem.isChecked,
            title: checklistItem.title
        )
    }


    func itemUpdated(_ checklistItem: Checklist.Item) {
        guard let updatedDataSourceIndex = dataSource.models.firstIndex(of: checklistItem) else {
            preconditionFailure("Unable to find checklist in data source models")
        }
        
        switch checklistItem.reminderState {
        case .needsScheduling, .needsRescheduling:
            checklistItem.scheduleReminder()
        case .needsCanceling:
            checklistItem.cancelReminder()
        default:
            break
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let indexPath = IndexPath(row: updatedDataSourceIndex, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    func cellDeleted(at indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
