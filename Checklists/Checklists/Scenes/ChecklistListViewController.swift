//
//  ChecklistListViewController.swift
//  Checklists
//
//  Created by Brian Sipple on 6/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class ChecklistListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    var modelController: ChecklistItemsModelController!
    private var checklistTableDataSource: TableViewDataSource<ChecklistItem>!
}


// MARK: - Lifecycle

extension ChecklistListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(modelController != nil, "No model controller was set")
        
        loadChecklists()
    }
}



// MARK: - Navigation

extension ChecklistListViewController {
    @IBAction func unwindFromCancelingAdd(unwindSegue: UIStoryboardSegue) {}
    
    @IBAction func unwindFromSubmittingAdd(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}


// MARK: - Event Handling

extension ChecklistListViewController {
    
    @IBAction func addItemTapped() {
        modelController.createNewItem { (newItemResult) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                switch newItemResult {
                case .success(let newItem):
                    let newRowIndex = self.tableView.numberOfRows(inSection: 0)
                    let newRowIndexPath = IndexPath(row: newRowIndex, section: 0)
                    
                    self.checklistTableDataSource.models.append(newItem)
                    self.tableView.insertRows(at: [newRowIndexPath], with: .automatic)
                case .failure:
                    fatalError()
                }
            }
        }
    }
}



// MARK: - UITableViewDelegate

extension ChecklistListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            preconditionFailure("Failed to find cell")
        }
        
//        cell.accessoryType = cell.accessoryType == .none ? .checkmark : .none
        checklistTableDataSource.models[indexPath.row].isChecked.toggle()
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}


// MARK: - Private Helper Methods

private extension ChecklistListViewController {
    
    func loadChecklists() {
        modelController.loadChecklists { [weak self] checklistsResult in
            DispatchQueue.main.async {
                switch checklistsResult {
                case .success(let checklists):
                    self?.setupTableView(with: checklists)
                case .failure(let error):
                    print(error)
                    fatalError("Error while loading checklists:\n\n\(error.localizedDescription)")
                }
            }
        }
    }

    
    func setupTableView(with checklists: [ChecklistItem]) {
        let dataSource = TableViewDataSource(
            models: checklists,
            cellReuseIdentifier: R.reuseIdentifier.checklistTableCell.identifier,
            cellConfigurator: { [weak self] (checklist, cell) in
                self?.configure(cell, with: checklist)
            },
            cellDeletionHandler: { [weak self] (_, cell, indexPath) in
                self?.cellDeletedFromTable(cell, at: indexPath)
            }
        )

        self.checklistTableDataSource = dataSource
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.reloadData()
    }
    
    
    func configure(_ cell: UITableViewCell, with checklist: ChecklistItem) {
        cell.textLabel?.text = checklist.title
        cell.accessoryType = checklist.isChecked ? .checkmark : .none
    }
    
    
    func cellDeletedFromTable(_ cell: UITableViewCell, at indexPath: IndexPath) {
        modelController.removeItem(at: indexPath.row) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                case .failure:
                    fatalError()
                }
            }
        }
    }
}
