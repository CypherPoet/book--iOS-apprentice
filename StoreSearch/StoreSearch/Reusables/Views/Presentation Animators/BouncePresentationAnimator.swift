//
//  BouncePresentationAnimator.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/31/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

final class BouncePresentationAnimator: NSObject {
    private let duration: TimeInterval = 0.4
}


extension BouncePresentationAnimator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        duration
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to)
        else { return }
        
        let containerView = transitionContext.containerView
        toView.frame = transitionContext.finalFrame(for: toViewController)
        
        containerView.addSubview(toView)
        
        toView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animateKeyframes(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [.calculationModeCubic],
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0.0,
                    relativeDuration: 0.5,
                    animations: {
                        toView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    }
                )
                UIView.addKeyframe(
                    withRelativeStartTime: 0.5,
                    relativeDuration: 0.333,
                    animations: {
                        toView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    }
                )
                UIView.addKeyframe(
                    withRelativeStartTime: 0.8333,
                    relativeDuration: 0.1777,
                    animations: {
                        toView.transform = .identity
                    }
                )
            },
            completion: { didComplete in
                transitionContext.completeTransition(didComplete)
            }
        )
    }
    
    
}
