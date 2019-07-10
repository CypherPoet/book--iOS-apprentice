//
//  TaggedLocationsListViewController.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/9/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class TaggedLocationsListViewController: UIViewController, Storyboarded {
    @IBOutlet private var tableView: UITableView!
    
    var modelController: TaggedLocationsModelController!
    private var dataSource: TableViewDataSource<Location>?

    private var locations: [Location]? {
        didSet {
            guard let locations = locations else { return }
            
            DispatchQueue.main.async {
                let dataSource = self.makeTableViewDataSource(with: locations)
                
                self.dataSource = dataSource
                self.tableView.dataSource = dataSource
                self.tableView.reloadData()
            }
        }
    }
}



// MARK: - Lifecycle

extension TaggedLocationsListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(modelController != nil, "No modelController was set")
        
        setupTableView()
        loadLocations()
    }
}


// MARK: - Private Helpers

private extension TaggedLocationsListViewController {
    
    func makeTableViewDataSource(with locations: [Location]) -> TableViewDataSource<Location> {
        return TableViewDataSource(
            models: locations,
            cellReuseIdentifier: R.reuseIdentifier.locationTableCell.identifier,
            cellConfigurator: { [weak self] (location, cell) in
                guard let cell = cell as? LocationTableViewCell else {
                    preconditionFailure("Unexpected cell type")
                }
                
                self?.configure(cell, with: location)
            }
        )
    }

    
    func loadLocations() {
        modelController.fetchLocations { [weak self] dataResult in
            guard let self = self else { return }
            
            switch dataResult {
            case .success(let locations):
                self.locations = locations
            case .failure:
                break
            }
        }
    }


    func setupTableView() {
        let cellNib = LocationTableViewCell.nib
        
        tableView.register(
            cellNib,
            forCellReuseIdentifier: R.reuseIdentifier.locationTableCell.identifier
        )
        
        tableView.dataSource = dataSource
    }
    
    
    func configure(_ cell: LocationTableViewCell, with location: Location) {
        cell.viewModel = .init(location: location)
    }
}
