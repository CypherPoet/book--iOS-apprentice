//
//  SearchResultDetailsViewController+ViewModel.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/28/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


extension SearchResultDetailsViewController {
    
    struct ViewModel {
        var artworkImage: UIImage?
        var artistName: String?
        var contentType: APIResultKind
        var contentGenre: String?
        var price: Price
        var storeURL: URL?
        var artworkImageURL: URL?
    }
}


// MARK: - Computeds
extension SearchResultDetailsViewController.ViewModel {
    var headerImage: UIImage? { artworkImage ?? R.image.storeLogo() }
    var artistNameText: String { artistName ?? "(Unknown Artist)" }
    var contentTypeText: String { contentType.displayName }
    
    var priceText: String? {
        if price.value == 0 {
            return "Free"
        } else {
            return price.formattedString
        }
    }
}
