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
    
    var modelController: ChecklistModelController!
    private var checklistTableDataSource: TableViewDataSource<Checklist>!
}


// MARK: - Computeds

extension ChecklistListViewController {
    var newRowIndexPath: IndexPath {
        let nextRowIndex = tableView.numberOfRows(inSection: 0)
        
        return IndexPath(row: nextRowIndex, section: 0)
    }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case R.segue.checklistListViewController.showChecklistItemList.identifier:
            handleSegueToChecklistItemList(using: segue)
        case R.segue.checklistListViewController.showAddItemView.identifier:
            handleSegueToAddChecklist(using: segue)
        default:
            preconditionFailure("Uknown segue")
        }
    }
    
    
    func handleSegueToAddChecklist(using segue: UIStoryboardSegue) {
        guard let addChecklistVC = segue.destination as? AddChecklistViewController else {
            fatalError()
        }
        
        addChecklistVC.delegate = self
    }
    
    
    func handleSegueToChecklistItemList(using segue: UIStoryboardSegue) {
        guard
            let checklistItemListVC = segue.destination as? ChecklistItemListViewController,
            let selectedRowIndex = tableView.indexPathForSelectedRow
        else {
            fatalError()
        }
        
        let checklist = checklistTableDataSource.models[selectedRowIndex.row]
        checklistItemListVC.modelController = ChecklistItemsModelController(checklist: checklist)
    }
}


// MARK: - Event Handling

extension ChecklistListViewController {
    
}


// MARK: - AddChecklistViewControllerDelegate

extension ChecklistListViewController: AddChecklistViewControllerDelegate {
    
    func addChecklistViewControllerDidCancel(_ viewController: AddChecklistViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func addChecklistViewController(
        _ viewController: AddChecklistViewController,
        didFinishAdding newChecklist: Checklist
    ) {
        navigationController?.popViewController(animated: true)
        add(newChecklist, at: newRowIndexPath)
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

    
    func setupTableView(with checklists: [Checklist]) {
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
        tableView.reloadData()
    }
    
    
    func configure(_ cell: UITableViewCell, with checklist: Checklist) {
        cell.textLabel?.text = checklist.title
    }
    
    
    func cellDeletedFromTable(_ cell: UITableViewCell, at indexPath: IndexPath) {
        modelController.removeChecklist(at: indexPath.row) { [weak self] result in
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
    
    
    func add(_ checklist: Checklist, at indexPath: IndexPath) {
        modelController.add(checklist, at: indexPath.row) { [weak self] (newItemResult) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch newItemResult {
                case .success(let newItem):
                    self.checklistTableDataSource.models.append(newItem)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                case .failure:
                    fatalError()
                }
            }
        }
    }
}
