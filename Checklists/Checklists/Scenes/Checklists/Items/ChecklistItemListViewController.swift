//
//  ChecklistItemListViewController.swift
//  Checklists
//
//  Created by Brian Sipple on 6/6/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class ChecklistItemListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var modelController: ChecklistItemsModelController!
    var dataSource: TableViewDataSource<ChecklistItem>!
}


// MARK: - Lifecycle

extension ChecklistItemListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(modelController != nil, "No model controller set")
        
        setupTableView(with: modelController.checklistItems)
    }
}


// MARK: - UITableViewDelegate

extension ChecklistItemListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.models[indexPath.row].isChecked.toggle()
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}


// MARK: - Private Helpers

private extension ChecklistItemListViewController {
    
    func setupTableView(with checklistItems: [ChecklistItem]) {
        let dataSource = TableViewDataSource(
            models: checklistItems,
            cellReuseIdentifier: R.reuseIdentifier.checklistItemTableCell.identifier,
            cellConfigurator: { (checklistItem, cell) in
                cell.textLabel?.text = checklistItem.title
                cell.accessoryType = checklistItem.isChecked ? .checkmark : .none
            }
//            cellDeletionHandler: { [weak self] (checklistItem, cell, indexPath) in
//
//            }
        )
        
        self.dataSource = dataSource
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
}
