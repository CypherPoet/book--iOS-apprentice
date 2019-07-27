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
            return "All"
        case .music:
            return "🎵 Music"
        case .software:
            return "🖥 Software"
        case .ebooks:
            return "📘 E-Books"
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
