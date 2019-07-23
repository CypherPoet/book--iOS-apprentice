//
//  SearchResultTableViewCell.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/23/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    @IBOutlet private var thumbnailImageView: UIImageView!
    @IBOutlet private var resultTitleLabel: UILabel!
    @IBOutlet private var artistNameLabel: UILabel!
    
    
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { self.render(with: viewModel) }
        }
    }
}


// MARK: - Computeds

extension SearchResultTableViewCell {
    
    static var nib: UINib {
        UINib(nibName: R.nib.searchResultTableViewCell.name, bundle: nil)
    }
}


// MARK: - Lifecycle

extension SearchResultTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


// MARK: - Private Helpers

private extension SearchResultTableViewCell {
    
    func render(with viewModel: ViewModel) {
        thumbnailImageView.image = viewModel.thumbnailImage
        resultTitleLabel.text = viewModel.resultTitle
        artistNameLabel.text = viewModel.artistName
    }
}
