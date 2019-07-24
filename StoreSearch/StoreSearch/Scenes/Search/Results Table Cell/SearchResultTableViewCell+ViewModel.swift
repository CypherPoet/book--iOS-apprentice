//
//  SearchResultTableViewCell+ViewModel.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/23/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


extension SearchResultTableViewCell {
    
    struct ViewModel {
        var resultImage: UIImage?
        var resultTitle: String
        var artistName: String?
    }
}


extension SearchResultTableViewCell.ViewModel {
    
    var thumbnailImage: UIImage? { resultImage ?? UIImage(systemName: "doc") }
}
