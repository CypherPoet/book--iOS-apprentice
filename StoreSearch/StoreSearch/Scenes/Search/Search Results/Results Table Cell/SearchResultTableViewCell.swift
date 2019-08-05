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
    
    var imageDownloadToken: DownloadTaskToken?
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
    
        selectedBackgroundView = UIView.selectedTableCellBackground
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageDownloadToken?.cancel()
        imageDownloadToken = nil
    }
}


// MARK: - Core Methods

extension SearchResultTableViewCell {
    
    func configure(with searchResult: SearchResult) {
        if viewModel == nil {
            viewModel = SearchResultTableViewCell.ViewModel(
                resultTitle: searchResult.title,
                artistName: searchResult.artistName,
                contentType: searchResult.contentType
            )
        } else {
            viewModel?.resultTitle = searchResult.title
            viewModel?.artistName = searchResult.artistName
            viewModel?.contentType = searchResult.contentType
        }
    }
}


// MARK: - Private Helpers

private extension SearchResultTableViewCell {
    
    func render(with viewModel: ViewModel) {
        thumbnailImageView.image = viewModel.thumbnailImage
        resultTitleLabel.text = viewModel.titleText
        artistNameLabel.text = viewModel.subtitleText
    }
}
