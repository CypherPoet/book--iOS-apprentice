//
//  UIColor+Theme.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/23/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


extension UIColor {
        
    enum Theme {
        private static func color(named name: String) -> UIColor {
            UIColor(named: name) ?? .systemPurple
        }
        
        static let background = color(named: R.color.background.name)
        static let tint = color(named: R.color.tint.name)
        static let accent1 = color(named: R.color.accent1.name)
    }
}
