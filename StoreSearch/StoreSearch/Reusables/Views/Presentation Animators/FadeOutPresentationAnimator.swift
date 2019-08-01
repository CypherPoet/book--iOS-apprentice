//
//  FadeOutPresentationAnimator.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/31/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

final class FadeOutPresentationAnimator: NSObject {
    private let duration: TimeInterval = 0.3
}


extension FadeOutPresentationAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [.curveEaseIn],
            animations: {
                fromView.alpha = 0
                fromView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            },
            completion: { didComplete in
                transitionContext.completeTransition(didComplete)
            }
        )
    }
}
