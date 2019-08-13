//
//  UIViewController+IsViewCompact.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/13/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

extension UIViewController {
    var isViewHorizontallyCompact: Bool {
        traitCollection.horizontalSizeClass == .compact
    }
    
    var isViewVerticallyCompact: Bool {
        traitCollection.verticalSizeClass == .compact
    }
}
