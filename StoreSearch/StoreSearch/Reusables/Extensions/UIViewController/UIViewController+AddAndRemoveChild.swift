//
//  UIViewController+AddAndRemoveChild.swift
//  iOSReusables
//
//  Created by Brian Sipple on 5/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

@nonobjc extension UIViewController {
    
    func add(
        child childViewController: UIViewController,
        toView targetView: UIView? = nil,
        usingFrame customFrame: CGRect? = nil
    ) {
        guard let targetView = targetView ?? view else { return }
        
        childViewController.view.frame = customFrame ?? childViewController.view.frame
        
        addChild(childViewController)
        targetView.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    
    func performRemoval() {
        // check that this view controller is actually added to
        // a parent before removing it.
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
