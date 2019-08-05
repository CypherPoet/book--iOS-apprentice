//
//  UIView+AnimateVisibility.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/22/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

private let defaultDuration: TimeInterval = 0.33


extension UIView {
    
    func fadeIn(
        duration: TimeInterval = defaultDuration,
        delay: TimeInterval = 0,
        then completionHandler: (() -> Void)? = nil
    ) {
        self.alpha = 0
        self.isHidden = false
        
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.curveEaseOut],
            animations: {
                self.alpha = 1
            },
            completion: { _ in
                self.isHidden = false
                completionHandler?()
            }
        )
    }
    
    
    func fadeOut(
        duration: TimeInterval = defaultDuration,
        delay: TimeInterval = 0,
        then completionHandler: (() -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.curveEaseIn],
            animations: {
                self.alpha = 0
            },
            completion: { _ in
                self.isHidden = true
                completionHandler?()
            }
        )
    }
}
