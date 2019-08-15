//
//  AppMenuViewController.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/13/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


protocol AppMenuViewControllerDelegate: class {
    func viewControllerDidSelectSendMail(_ controller: AppMenuViewController)
}


class AppMenuViewController: UITableViewController {
    weak var delegate: AppMenuViewControllerDelegate?
}


// MARK: - UITableViewDelegate
extension AppMenuViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            delegate?.viewControllerDidSelectSendMail(self)
        case (0, _):
            break // No functionality yet for other cells in section
        default:
            fatalError("Unknown table cell selected")
        }
    }
}


extension AppMenuViewController: Storyboarded {}
