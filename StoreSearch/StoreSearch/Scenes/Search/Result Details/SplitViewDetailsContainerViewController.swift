//
//  SplitViewDetailsContainerViewController.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/14/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


protocol SplitViewDetailsContainerViewControllerDelegate: class {
    func viewControllerDidTapAppMenuButton(_ controller: SplitViewDetailsContainerViewController)
}


class SplitViewDetailsContainerViewController: UIViewController {
    weak var delegate: SplitViewDetailsContainerViewControllerDelegate?
}


// MARK: - Event Handling
extension SplitViewDetailsContainerViewController {
    
    @IBAction func appMenuButtonTapped(_ sender: UIBarButtonItem) {
        delegate?.viewControllerDidTapAppMenuButton(self)
    }
}


extension SplitViewDetailsContainerViewController: Storyboarded {}
