//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/22/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


struct SearchResult {
    private let identifier = UUID()
    
    private let kind: String?
    private let wrapperType: String?
    private let currencyCode: String
    
    let artistName: String?
    let trackName: String?
    let collectionName: String?
    let primaryGenre: String?
    let genreSet: [String]?
    let trackPrice: Double?
    let collectionPrice: Double?
    let itemPrice: Double?
    let smallThumbnailURL: URL?
    let largeThumbnailURL: URL?
    let collectionViewURL: URL?
    let trackViewURL: URL?
}


// MARK: - Codable

extension SearchResult: Codable {
    enum CodingKeys: String, CodingKey {
        case artistName
        case trackName
        case collectionName
        case kind
        case wrapperType
        case trackPrice
        case collectionPrice
        case itemPrice
        case currencyCode = "currency"
        case smallThumbnailURL = "artworkUrl60"
        case largeThumbnailURL = "artworkUrl100"
        case collectionViewURL = "collectionViewUrl"
        case trackViewURL = "trackViewUrl"
        case primaryGenre = "primaryGenreName"
        case genreSet = "genres"
    }
}


// MARK: - Hashable

extension SearchResult: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}


// MARK: - CustomStringConvertible

extension SearchResult: CustomStringConvertible {
    var description: String {
        """
        Kind: \(kind ?? "(No Kind)"),
        Title: \(title ?? "(No Title)"),
        Artist Name: \(artistName ?? "(No Artist Name)")
        """
    }
}




// MARK: - Computeds

extension SearchResult {
    var title: String? { trackName ?? collectionName }
    var storeURL: URL? { trackViewURL ?? collectionViewURL }
    var contentType: APIResultKind { .init(rawString: kind ?? wrapperType) }

    var price: Price {
        let priceValue = trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
        
        return Price(currencyCode: currencyCode, value: priceValue)
    }
    
    
    var genres: [String]? {
        primaryGenre != nil ? [primaryGenre!] : genreSet
    }
}
