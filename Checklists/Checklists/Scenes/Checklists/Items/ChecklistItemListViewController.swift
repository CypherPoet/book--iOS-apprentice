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
        
        title = modelController.checklistTitle
        setupTableView(with: modelController.checklistItems)
    }
}


// MARK: - UITableViewDelegate

extension ChecklistItemListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        dataSource.models[indexPath.row].isChecked.toggle()
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}


// MARK: - Private Helpers

private extension ChecklistItemListViewController {
    
    func setupTableView(with checklistItems: [ChecklistItem]) {
        let cellReuseId = R.reuseIdentifier.checklistItemTableCell.identifier
        
        let dataSource = TableViewDataSource(
            models: checklistItems,
            cellReuseIdentifier: cellReuseId,
            cellConfigurator: { (checklistItem, cell) in
                guard let cell = cell as? ChecklistItemTableViewCell else { fatalError() }
                
                cell.viewModel = ChecklistItemTableViewCell.ViewModel(
                    isChecked: checklistItem.isChecked,
                    title: checklistItem.title
                )
            }
//            cellDeletionHandler: { [weak self] (checklistItem, cell, indexPath) in
//
//            }
        )
        
        self.dataSource = dataSource
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        let cellNib = ChecklistItemTableViewCell.nib
        tableView.register(cellNib, forCellReuseIdentifier: cellReuseId)
    }
}
