//
//  DimmedModalPresentationManager.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/29/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


final class DimmedModalPresentationManager: NSObject {
    var modalPresentationController: DimmedModalPresentationController?
}


extension DimmedModalPresentationManager: UIViewControllerTransitioningDelegate {
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let dimmedModalPresentationController = DimmedModalPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
        
        self.modalPresentationController = dimmedModalPresentationController
        
        return dimmedModalPresentationController
    }
    
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        BouncePresentationAnimator()
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        FadeOutPresentationAnimator()
    }
}
