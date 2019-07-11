//
//  TaggedLocationsListViewController.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/9/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreData


protocol TaggedLocationsListViewControllerDelegate: class {
    func viewController(
        _ viewController: TaggedLocationsListViewController,
        didSelectEditingFor location: Location
    )
}


class TaggedLocationsListViewController: UIViewController, Storyboarded {
    @IBOutlet private var tableView: UITableView!

    weak var delegate: TaggedLocationsListViewControllerDelegate?
    var modelController: TaggedLocationsModelController!

    fileprivate typealias DataSource = FetchedResultsTableViewDataSource<Location>
    private lazy var dataSource: DataSource = makeTableViewDataSource()
}


// MARK: - Lifecycle

extension TaggedLocationsListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(modelController != nil, "No modelController was set")
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        setupTableView(with: dataSource)
        modelController.fetchedResultsController.delegate = self
        modelController.fetchLocations()
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }
}


// MARK: - UITableViewDelegate

extension TaggedLocationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = dataSource.model(at: indexPath)
        
        delegate?.viewController(self, didSelectEditingFor: location)
    }
}


extension TaggedLocationsListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("🥞🥞🥞 NSFetchedResultsController: controllerWillChangeContent")
        if isViewInWindow {
            tableView.beginUpdates()
        }
    }
    
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for changeType: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {

        switch changeType {
        case .insert:
            guard let relevantIndexPath = newIndexPath else { fatalError("Unable to find a usable index path") }
            
            print("🥞🥞🥞 NSFetchedResultsController: object changed (insert)")
            tableView.insertRows(at: [relevantIndexPath], with: .automatic)
        case .delete:
            guard let relevantIndexPath = indexPath else { fatalError("Unable to find a usable index path") }
            
            print("🥞🥞🥞 NSFetchedResultsController: object changed (delete)")
            tableView.deleteRows(at: [relevantIndexPath], with: .automatic)
        case .update:
            guard let relevantIndexPath = indexPath else { fatalError("Unable to find a usable index path") }
            guard let cell = tableView.cellForRow(at: relevantIndexPath) else {
                fatalError("Unable to find cell at index path")
            }

            print("🥞🥞🥞 NSFetchedResultsController: object changed (update)")
            let location = dataSource.model(at: relevantIndexPath)
            
            configure(cell, with: location)
        case .move:
            guard
                let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath
            else { fatalError("Unable to find usable index paths") }
            
            print("🥞🥞🥞 NSFetchedResultsController: object changed (move)")
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
        @unknown default:
            break
        }
    }
    
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for changeType: NSFetchedResultsChangeType
    ) {
        switch changeType {
        case .insert:
            print("🥞🥞🥞 NSFetchedResultsController: section changed (insert)")
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            print("🥞🥞🥞 NSFetchedResultsController: section changed (delete)")
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .update:
            print("🥞🥞🥞 NSFetchedResultsController: section changed (update)")
        case .move:
            print("🥞🥞🥞 NSFetchedResultsController: section changed (move)")
        @unknown default:
            break
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("🥞🥞🥞 NSFetchedResultsController: didChangeContent")
        if isViewInWindow {
            tableView.endUpdates()
        }
    }
}



// MARK: - Private Helpers

private extension TaggedLocationsListViewController {
    
    func setupTableView(with dataSource: DataSource) {
        let cellNib = LocationTableViewCell.nib
        
        tableView.register(
            cellNib,
            forCellReuseIdentifier: R.reuseIdentifier.locationTableCell.identifier
        )
        
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    
    func configure(_ cell: UITableViewCell, with location: Location) {
        guard let cell = cell as? LocationTableViewCell else {
            preconditionFailure("Unknwown cell type found in table view")
        }
        
        cell.viewModel = .init(location: location)
    }
    
    
    
    func makeTableViewDataSource() -> DataSource {
        FetchedResultsTableViewDataSource(
            controller: modelController.fetchedResultsController,
            cellReuseIdentifier: R.reuseIdentifier.locationTableCell.identifier,
            cellConfigurator: { [weak self] (location, cell) in
                self?.configure(cell, with: location)
            },
            cellDeletionHandler: { [weak self] (location, cell, indexPath) in
                self?.modelController.delete(location)
            }
        )
    }
    
}
