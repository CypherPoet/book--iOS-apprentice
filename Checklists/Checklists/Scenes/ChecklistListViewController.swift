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
    var stateController: StateController!
    
    private var tableDataSource: TableViewDataSource<Checklist>!
}


// MARK: - Computeds

extension ChecklistListViewController {
    
    var newRowIndexPath: IndexPath {
        let nextRowIndex = tableView.numberOfRows(inSection: 0)
        
        return IndexPath(row: nextRowIndex, section: 0)
    }
    
    
    var checklistForSelectedRow: Checklist {
        guard let selectedRowIndex = tableView.indexPathForSelectedRow else {
            preconditionFailure("Unable to find tableView.indexPathForSelectedRow")
        }
        
        return tableDataSource.models[selectedRowIndex.row]
    }
}



// MARK: - Lifecycle

extension ChecklistListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(modelController != nil, "No model controller was set")
        assert(stateController != nil, "No state controller was set")
        
        modelController.loadChecklists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let checklists):
                    self?.render(with: checklists)
                case .failure:
                    // TODO: Better handling here
                    fatalError()
                }
            }
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
    }
}


// MARK: - Navigation

extension ChecklistListViewController {
    
    @IBAction func unwindToChecklistsList(unwindSegue: UIStoryboardSegue) {}
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case R.segue.checklistListViewController.showChecklistItems.identifier:
            guard let indexPath = sender as? IndexPath ?? tableView.indexPathForSelectedRow else {
                preconditionFailure("Unable to find index path for checklist")
            }
            
            handleSegueToChecklistItemList(using: segue, and: indexPath)
        case R.segue.checklistListViewController.showAddChecklistView.identifier:
            handleSegueToAddChecklist(using: segue)
        case R.segue.checklistListViewController.showEditChecklistView.identifier:
            guard let cell = sender as? UITableViewCell else { fatalError() }
            
            handleSegueToEditChecklist(using: segue, and: cell)
        default:
            preconditionFailure("Uknown segue")
        }
    }
    
    
    func handleSegueToAddChecklist(using segue: UIStoryboardSegue) {
        guard let viewController = segue.destination as? AddEditChecklistViewController else {
            preconditionFailure("Segue destination doesn't match expected view controller")
        }
        
        viewController.delegate = self
    }
    
    
    func handleSegueToEditChecklist(using segue: UIStoryboardSegue, and cell: UITableViewCell) {
        guard let viewController = segue.destination as? AddEditChecklistViewController else {
            preconditionFailure("Segue destination doesn't match expected view controller")
        }
        
        viewController.delegate = self
        viewController.checklistToEdit = checklistFor(cell)
    }
    
    
    func handleSegueToChecklistItemList(using segue: UIStoryboardSegue, and indexPath: IndexPath) {
        guard let viewController = segue.destination as? ChecklistItemListViewController else {
            preconditionFailure("Segue destination doesn't match expected view controller")
        }

        stateController.indexPathOfCurrentChecklist = indexPath
        viewController.checklist = tableDataSource.models[indexPath.row]
        viewController.modelController = modelController
    }
}


// MARK: - UINavigationControllerDelegate

extension ChecklistListViewController: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        if viewController === self {
            stateController.indexPathOfCurrentChecklist = nil
        }
    }
}
    

// MARK: - ChecklistFormViewControllerDelegate

extension ChecklistListViewController: ChecklistFormViewControllerDelegate {
    
    func checklistFormViewControllerDidCancel(_ viewController: UIViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func checklistFormViewController(
        _ viewController: UIViewController,
        didFinishAdding newChecklist: Checklist
    ) {
        navigationController?.popViewController(animated: true)
        add(newChecklist, at: newRowIndexPath)
    }
    
    
    func checklistFormViewController(
        _ viewController: UIViewController,
        didFinishEditing checklist: Checklist
    ) {
        navigationController?.popViewController(animated: true)
        checklistUpdated(checklist)
    }
}


// MARK: - UITableViewDelegate

extension ChecklistListViewController: UITableViewDelegate {
    
    /// Show Items
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(
            withIdentifier: R.segue.checklistListViewController.showChecklistItems.identifier,
            sender: indexPath
        )
    }
    
    /// Show Edit View
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { fatalError() }
        
        performSegue(
            withIdentifier: R.segue.checklistListViewController.showEditChecklistView.identifier,
            sender: cell
        )
    }
}



// MARK: - Private Helper Methods

private extension ChecklistListViewController {
    
    func render(with checklists: [Checklist]) {
        setupTableView(with: checklists)
        
        if let indexPathToRestore = stateController.indexPathOfCurrentChecklist {
            guard checklists.count > indexPathToRestore.row else {
                // Reset because something is out of sync
                stateController.indexPathOfCurrentChecklist = nil
                return
            }
            
            performSegue(
                withIdentifier: R.segue.checklistListViewController.showChecklistItems.identifier,
                sender: indexPathToRestore
            )
        }
    }
    
    
    func setupTableView(with checklists: [Checklist]) {
        let cellReuseID = R.reuseIdentifier.checklistTableViewCell.identifier
        
        let dataSource = TableViewDataSource(
            models: checklists,
            cellReuseIdentifier: cellReuseID,
            cellConfigurator: { [weak self] (checklist, cell) in
                self?.configure(cell, with: checklist)
            },
            cellDeletionHandler: { [weak self] (_, cell, indexPath) in
                self?.cellDeletedFromTable(cell, at: indexPath)
            }
        )

        self.tableDataSource = dataSource
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.register(ChecklistTableViewCell.nib, forCellReuseIdentifier: cellReuseID)
        tableView.reloadData()
    }
    
    
    func configure(_ cell: UITableViewCell, with checklist: Checklist) {
        guard let cell = cell as? ChecklistTableViewCell else {
            preconditionFailure("Unknown cell type")
        }
        
        cell.viewModel = ChecklistTableViewCell.ViewModel(
            title: checklist.title,
            unfinishedItemCount: checklist.uncheckedCount,
            iconName: nil
        )
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
        modelController.create(checklist) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let newChecklist):
                    self.tableDataSource.models.append(newChecklist)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                case .failure:
                    fatalError()
                }
            }
        }
    }
    
    
    func checklistFor(_ cell: UITableViewCell) -> Checklist {
        guard let indexPath = tableView.indexPath(for: cell) else {
            preconditionFailure("Unable to find index path for cell")
        }
        
        return tableDataSource.models[indexPath.row]
    }
    
    
    func checklistUpdated(_ checklist: Checklist) {
        guard let updatedDataSourceIndex = tableDataSource.models.firstIndex(of: checklist) else {
            preconditionFailure("Unable to find checklist in data source models")
        }
        
        let updatedChecklistIndexPath = IndexPath(row: updatedDataSourceIndex, section: 0)
        
        tableDataSource.models[updatedDataSourceIndex] = checklist
        tableView.reloadRows(at: [updatedChecklistIndexPath], with: .automatic)
    }
}
