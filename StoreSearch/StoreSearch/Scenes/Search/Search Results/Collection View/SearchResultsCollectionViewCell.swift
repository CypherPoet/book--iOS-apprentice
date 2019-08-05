//
//  SearchResultsCollectionViewCell.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/3/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class SearchResultsCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var imageContainerView: UIView!
    @IBOutlet private var cellContainerView: UIView!
    @IBOutlet private var resultImageView: UIImageView!
    
    
    var resultImage: UIImage! {
        didSet {
            DispatchQueue.main.async {
                self.resultImageView.image = self.resultImage
            }
        }
    }
    
    var imageDownloadingToken: DownloadTaskToken?
}


// MARK: - Computeds
extension SearchResultsCollectionViewCell {

    static var nib: UINib {
        UINib(nibName: R.nib.searchResultsCollectionViewCell.name, bundle: nil)
    }
}


// MARK: - Lifecycle
extension SearchResultsCollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleViews()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageDownloadingToken?.cancel()
    }
}


// MARK: - Private Helpers
extension SearchResultsCollectionViewCell {
    
    func styleViews() {
        imageContainerView.layer.cornerRadius = imageContainerView.bounds.width * 0.1
        imageContainerView.clipsToBounds = true
        
        cellContainerView.layer.cornerRadius = cellContainerView.bounds.width * 0.1
        cellContainerView.layer.shadowOffset = .zero
        cellContainerView.layer.shadowOpacity = 1
//        cellContainerView.layer.masksToBounds = true
        cellContainerView.layer.shadowColor = UIColor.Theme.accent1.cgColor
        cellContainerView.layer.shadowRadius = 10
    }
}
