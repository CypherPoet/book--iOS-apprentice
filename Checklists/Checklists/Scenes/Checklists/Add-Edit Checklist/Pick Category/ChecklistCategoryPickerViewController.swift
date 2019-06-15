//
//  ChecklistCategoryPickerViewController.swift
//  Checklists
//
//  Created by Brian Sipple on 6/14/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class ChecklistCategoryPickerViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    weak var delegate: ChecklistCategoryPickerViewControllerDelegate!
    var availableCategories: [Checklist.Category]!
    var dataSource: TableViewDataSource<Checklist.Category>!
}


// MARK: - Lifecycle

extension ChecklistCategoryPickerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(delegate != nil, "No delegate was set")
        assert(availableCategories != nil, "No categories were set")

        render(with: availableCategories)
    }
}


// MARK: - UITableViewDelegate

extension ChecklistCategoryPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = dataSource.models[indexPath.row]
        
        delegate.checklistCategoryPickerViewController(self, didPick: category)
    }
}


// MARK: - Private Helpers

private extension ChecklistCategoryPickerViewController {
    
    func render(with categories: [Checklist.Category]) {
        let dataSource = TableViewDataSource(
            models: categories,
            cellReuseIdentifier: R.reuseIdentifier.categoryTableCell.identifier,
            cellConfigurator: { (category, cell) in
                cell.imageView?.image = category.iconImage
                cell.imageView?.tintColorDidChange()
                cell.textLabel?.text = category.title
            }
        )
        
        self.dataSource = dataSource
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
}
