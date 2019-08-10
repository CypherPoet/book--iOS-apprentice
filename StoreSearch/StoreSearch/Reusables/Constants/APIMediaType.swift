//
//  SearchScope.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/26/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


enum APIMediaType: CaseIterable {
        case all
        case music
        case software
        case ebooks
}


extension APIMediaType {
    static var allTitles: [String] {
        allCases.map { $0.titleText }
    }
    

    var titleText: String {
        switch self {
        case .all:
            return NSLocalizedString(
                "🔎 All",
                comment: "Title for the \"All\" search bar scope value"
            )
        case .music:
            return NSLocalizedString(
                "🎵 Music",
                comment: "Title for the \"Music\" search bar scope value"
            )
        case .software:
            return NSLocalizedString(
                "🖥 Software",
                comment: "Title for the \"Software\" search bar scope value"
            )
        case .ebooks:
            return NSLocalizedString(
                "📘 E-Books",
                comment: "Title for the \"E-Books\" search bar scope value"
            )
        }
    }
    

    var queryParamValue: String {
        switch self {
        case .all:
            return "all"
        case .music:
            return "music"
        case .software:
            return "software"
        case .ebooks:
            return "ebook"
        }
    }
}
