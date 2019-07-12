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
    typealias SectionTitleConfigurator = (NSFetchedResultsSectionInfo) -> String
    
    
    private let fetchedResultsController: NSFetchedResultsController<Model>
    private let cellReuseIdentifier: String
    private let cellConfigurator: CellConfigurator?
    private let cellDeletionHandler: CellDeletionHandler?
    private let sectionTitleConfigurator: SectionTitleConfigurator?
    
    
    init(
        controller fetchedResultsController: NSFetchedResultsController<Model>,
        cellReuseIdentifier: String,
        cellConfigurator: CellConfigurator? = nil,
        cellDeletionHandler: CellDeletionHandler? = nil,
        sectionTitleConfigurator: SectionTitleConfigurator? = nil
    ) {
        self.fetchedResultsController = fetchedResultsController
        self.cellReuseIdentifier = cellReuseIdentifier
        self.cellConfigurator = cellConfigurator
        self.cellDeletionHandler = cellDeletionHandler
        self.sectionTitleConfigurator = sectionTitleConfigurator
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int { sections.count }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].numberOfObjects
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = sections[section]
        
        return sectionTitleConfigurator?(sectionInfo) ?? sectionInfo.name
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let model = self.model(at: indexPath)
        
        cellConfigurator?(model, cell)
        
        return cell
    }
    
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if
            editingStyle == .delete,
            let cellDeletionHandler = cellDeletionHandler
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
            let model = self.model(at: indexPath)
            
            cellDeletionHandler(model, cell, indexPath)
        }
    }
}


// MARK: - Public Helpers

extension FetchedResultsTableViewDataSource {
    
    var sections: [NSFetchedResultsSectionInfo] {
        guard let sections = fetchedResultsController.sections else {
            preconditionFailure("No sections found fetchedResultsController")
        }
        
        return sections
    }
    
    
    func model(at indexPath: IndexPath) -> Model {
        fetchedResultsController.object(at: indexPath)
    }
}
