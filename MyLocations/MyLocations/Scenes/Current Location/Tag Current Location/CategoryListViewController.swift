//
//  CategoryListViewController.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/4/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


protocol CategoryListViewControllerDelegate: class {
    func viewControllerDidCancel(_ controller: CategoryListViewController)
    func viewController(_ controller: CategoryListViewController, didSelect category: Location.Category)
}


class CategoryListViewController: UIViewController, Storyboarded {
    @IBOutlet private var tableView: UITableView!
    
    private lazy var dataSource = makeDataSource()
    
    private var selectedCellIndexPath: IndexPath? {
        didSet {
            guard let selectedCellIndexPath = selectedCellIndexPath else { return }
            
            DispatchQueue.main.async {
                self.selectedCellIndexPathDidChange(from: oldValue, to: selectedCellIndexPath)
            }
        }
    }
    
    var currentCategory: Location.Category?
    var categories: [Location.Category] = []
    weak var delegate: CategoryListViewControllerDelegate?
}


// MARK: - Lifecycle

extension CategoryListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}


// MARK: - UITableViewDelegate

extension CategoryListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndexPath = indexPath
        
        let selectedCategory = dataSource.models[indexPath.row]
        delegate?.viewController(self, didSelect: selectedCategory)
    }
}


// MARK: - Private Helpers

private extension CategoryListViewController {
    
    func makeDataSource() -> TableViewDataSource<Location.Category> {
        let dataSource = TableViewDataSource(
            models: categories,
            cellReuseIdentifier: R.reuseIdentifier.categoryTableCell.identifier,
            cellConfigurator: { [weak self] (category, cell) in
                guard let self = self else { return }
                
                cell.selectedBackgroundView = UIView.selectedTableCellBackgroundView
                cell.textLabel?.text = category.displayValue
                cell.accessoryType = category == self.currentCategory ? .checkmark : .none
            }
        )
        
        return dataSource
    }
    
    
    func setupTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    
    func selectedCellIndexPathDidChange(from oldValue: IndexPath?, to newValue: IndexPath) {
        if
            let previouslySelectedIndexPath = oldValue,
            let previouslySelectedCell = tableView.cellForRow(at: previouslySelectedIndexPath)
        {
            previouslySelectedCell.accessoryType = .none
        }
        
        if let newCell = tableView.cellForRow(at: newValue) {
            newCell.accessoryType = .checkmark
        }
    }
}
