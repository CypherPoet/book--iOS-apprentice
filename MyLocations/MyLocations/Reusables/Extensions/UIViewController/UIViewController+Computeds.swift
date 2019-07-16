//
//  UIViewController+Computeds.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/11/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


extension UIViewController {
    var isViewInWindow: Bool { isViewLoaded && view.window != nil }
}
