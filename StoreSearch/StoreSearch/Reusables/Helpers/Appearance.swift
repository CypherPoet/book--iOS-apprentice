//
//  Appearance.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/23/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


enum Appearance {
    
    enum Constants {
        static let modalCornerRadius: CGFloat = 14
    }
    
    
    enum SearchBar {
        static var standard: UIBarAppearance {
            let appearance = UIBarAppearance()
            
            appearance.backgroundColor = UIColor.Theme.background

            return appearance
        }
    }
    
    
    enum NavBar {
        static var standard: UINavigationBarAppearance {
            let appearance = UINavigationBarAppearance()
            
            appearance.backgroundColor = UIColor.Theme.background.withAlphaComponent(0.33)

            return appearance
        }
    }

    
    static func apply(to window: UIWindow) {
        window.tintColor = UIColor.Theme.tint
    }
    
    
    static func apply(to searchBar: UISearchBar) {
        searchBar.searchTextField.backgroundColor = UIColor.systemBackground
        
        let scopeButtonTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightText,
            .font: UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
        ]
        
        searchBar.setScopeBarButtonTitleTextAttributes(scopeButtonTextAttributes, for: .normal)
    }
    
    
    static func apply(to navBar: UINavigationBar) {
        navBar.standardAppearance = NavBar.standard
    }
}
