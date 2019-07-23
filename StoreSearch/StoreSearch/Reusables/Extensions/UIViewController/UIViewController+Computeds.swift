//
//  UIViewController+Computeds.swift
//  iOSReusables
//
//  Created by Brian Sipple on 7/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


extension UIViewController {
    var isViewInWindow: Bool { isViewLoaded && view.window != nil }
}
