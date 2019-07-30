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
        var headerImage: UIImage?
        var resultTitle: String?
        var artistName: String?
        var contentType: APIResultKind
        var contentGenre: String?
        var price: Double
    }
}
