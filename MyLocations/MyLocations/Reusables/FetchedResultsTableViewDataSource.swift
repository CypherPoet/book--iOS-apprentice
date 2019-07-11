//
//  FetchedResultsTableViewDataSource.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/11/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreData


final class FetchedResultsTableViewDataSource<Model: NSFetchRequestResult>: NSObject, UITableViewDataSource {
    typealias CellConfigurator = (Model, UITableViewCell) -> Void
    typealias CellDeletionHandler = (Model, UITableViewCell, IndexPath) -> Void
    
    
    private let fetchedResultsController: NSFetchedResultsController<Model>
    private let cellReuseIdentifier: String
    private let cellConfigurator: CellConfigurator?
    private let cellDeletionHandler: CellDeletionHandler?
    
    
    init(
        controller fetchedResultsController: NSFetchedResultsController<Model>,
        cellReuseIdentifier: String,
        cellConfigurator: CellConfigurator? = nil,
        cellDeletionHandler: CellDeletionHandler? = nil
    ) {
        self.fetchedResultsController = fetchedResultsController
        self.cellReuseIdentifier = cellReuseIdentifier
        self.cellConfigurator = cellConfigurator
        self.cellDeletionHandler = cellDeletionHandler
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionInfo(for: section).numberOfObjects
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let model = self.model(at: indexPath)
        
        cellConfigurator?(model, cell)
        
        return cell
    }
}


// MARK: - Public Helpers

extension FetchedResultsTableViewDataSource {
    
    func model(at indexPath: IndexPath) -> Model {
        fetchedResultsController.object(at: indexPath)
    }
}


// MARK: - Private Helpers

private extension FetchedResultsTableViewDataSource {
    
    func sectionInfo(for section: Int) -> NSFetchedResultsSectionInfo {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections found fetchedResultsController")
        }
        
        return sections[section]
    }
}
