//
//  SearchResultDetailsViewController.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/28/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


class SearchResultDetailsViewController: UIViewController {
    @IBOutlet private var resultTitleLabel: UILabel!
    @IBOutlet private var modalContentContainer: UIView!
    
    
    var viewModel: ViewModel?
}


// MARK: - Lifecycle
extension SearchResultDetailsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Event Handling
extension SearchResultDetailsViewController {
    
    @IBAction func closeButtonTapped() {
        dismiss(animated: true)
    }
    
}

//
//// MARK: - ContentHeightProviding
//extension SearchResultDetailsViewController: ContentHeightProviding {
//    var contentHeight: CGFloat? {
//        return view.bounds.height
//    }
//}


extension SearchResultDetailsViewController: Storyboarded {}


// MARK: - Private Helpers
private extension SearchResultDetailsViewController {

}
