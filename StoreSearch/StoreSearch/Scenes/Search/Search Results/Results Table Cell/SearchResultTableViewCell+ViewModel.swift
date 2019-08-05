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
        var downloadedThumbnailImage: UIImage?
        var resultTitle: String?
        var artistName: String?
        var contentType: APIResultKind
    }
}


extension SearchResultTableViewCell.ViewModel {
    var thumbnailImage: UIImage? { downloadedThumbnailImage ?? R.image.storeLogo() }

    var titleText: String { resultTitle ?? "(Untitled)" }

    var artistText: String { "\(artistName ?? "(Unknown Artist)")" }
    var contentTypeText: String { "(\(contentType.displayName))" }

    var subtitleText: String { "\(artistText) \(contentTypeText)" }
}
