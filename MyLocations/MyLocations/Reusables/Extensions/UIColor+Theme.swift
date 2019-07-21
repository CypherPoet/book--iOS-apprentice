//
//  UIColor+Theme.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/16/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


extension UIColor {
    enum Theme {
        
        private static func color(named name: String) -> UIColor {
            UIColor(named: name, in: Bundle.main, compatibleWith: nil) ?? .systemPurple
        }
        
        static let background = color(named: "Background")
        static let tint = color(named: "Tint")
        static let accent1 = color(named: "Accent 1")
        static let accent2 = color(named: "Accent 2")
        static let accent3 = color(named: "Accent 3")
    }
}
