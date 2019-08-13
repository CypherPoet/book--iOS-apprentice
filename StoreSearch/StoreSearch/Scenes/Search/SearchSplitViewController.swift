//
//  SearchSplitViewController.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/11/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class SearchSplitViewController: UISplitViewController {
}


// MARK: - Core Methods
extension SearchSplitViewController {
    
    func hideMasterPane() {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.preferredDisplayMode = .primaryHidden
            },
            completion: { _ in
                self.preferredDisplayMode = .automatic
            }
        )
    }
}


extension SearchSplitViewController: Storyboarded {}
