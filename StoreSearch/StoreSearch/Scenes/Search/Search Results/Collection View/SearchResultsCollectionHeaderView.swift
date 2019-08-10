//
//  SearchResultsCollectionHeaderView.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/3/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class SearchResultsCollectionHeaderView: UICollectionReusableView {
    @IBOutlet private var sectionHeaderLabel: UILabel!
    
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { self.render(with: viewModel) }
        }
    }
}



// MARK: - Computeds
extension SearchResultsCollectionHeaderView {
    static var nib: UINib {
        UINib(nibName: "SearchResultsCollectionHeaderView", bundle: nil)
    }
}



// MARK: - Lifecycle
extension SearchResultsCollectionHeaderView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}


// MARK: - Private Helpers
private extension SearchResultsCollectionHeaderView {

    func render(with viewModel: ViewModel) {
        sectionHeaderLabel.text = viewModel.headerText
    }
}


extension SearchResultsCollectionHeaderView {
    struct ViewModel {
        var resultCount: Int
        var searchText: String?
        
        var beginningText: String {
            "%d result(s) found for".localized(with: resultCount)
        }
        
        
        var headerText: String {
            "\(beginningText) \"\(searchText ?? "")\""
        }
    }
}
