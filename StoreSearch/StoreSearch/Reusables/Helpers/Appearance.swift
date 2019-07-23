//
//  Appearance.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/23/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


enum Appearance {
    
    enum SearchBar {
        static var standard: UIBarAppearance {
            let appearance = UIBarAppearance()
            
            appearance.backgroundColor = UIColor.Theme.background
            
            return appearance
        }
    }
    
    
    static func apply(to window: UIWindow) {
        window.tintColor = UIColor.Theme.tint
    }
    
    
    static func apply(to searchBar: UISearchBar) {
        searchBar.isTranslucent = true
//        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = UIColor.Theme.background
    }
}
