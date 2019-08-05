//
//  UIView+DisableAutoLayout.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/1/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


extension UIView {
    
    func disableAutoLayout() {
        removeConstraints(self.constraints)
        translatesAutoresizingMaskIntoConstraints = true
    }
}
