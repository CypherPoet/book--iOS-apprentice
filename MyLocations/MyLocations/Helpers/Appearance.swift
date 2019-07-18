//
//  Appearance.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/16/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


enum Appearance {
    
    enum Setting {
        static let modalCornerRadius = 14
    }
    
    
    enum NavBar {
        static var standard: UINavigationBarAppearance {
            let appearance = UINavigationBarAppearance()
            
            appearance.configureWithOpaqueBackground()
            
            appearance.largeTitleTextAttributes = [
                .foregroundColor: UIColor.Theme.accent1
            ]
            
            return appearance
        }
    }
    
    
    enum TabBar {
        static var standard: UITabBarAppearance {
            let appearance = UITabBarAppearance()
            
            appearance.configureWithOpaqueBackground()
            
            return appearance
        }
    }
    
    
    enum TabBarItem {
        static var standard: UITabBarItemAppearance {
            let appearance = UITabBarItemAppearance()

            /// This seems to have no effect 🤔
//            appearance.normal.iconColor = UIColor.Theme.tint
            
            return appearance
        }
    }
    

    
    static func apply(to window: UIWindow) {
//        window.tintColor = UIColor.Theme.tint
    }
    
    
    static func apply(to navBar: UINavigationBar) {
        navBar.standardAppearance = NavBar.standard
        navBar.compactAppearance = NavBar.standard
        navBar.scrollEdgeAppearance = NavBar.standard
        UINavigationBar.appearance().tintColor = UIColor.Theme.tint
    }
    
    
    static func apply(to tabBar: UITabBar) {
        tabBar.standardAppearance = TabBar.standard
        
/// So far, none of these seem to have any effect 🤔
//        tabBar.standardAppearance.stackedLayoutAppearance = TabBarItem.standard
//        tabBar.standardAppearance.compactInlineLayoutAppearance = TabBarItem.standard
//        tabBar.standardAppearance.inlineLayoutAppearance = TabBarItem.standard
        UITabBar.appearance().tintColor = UIColor.Theme.tint
    }
}
