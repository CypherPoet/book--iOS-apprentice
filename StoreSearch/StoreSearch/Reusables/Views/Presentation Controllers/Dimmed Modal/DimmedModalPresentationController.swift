//
//  DimmedPresentationController.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/28/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


final class DimmedModalPresentationController: UIPresentationController {
    private var dimmingView: DimmedGradientView!
    private var bottomOffset: CGFloat = 0
    
    var contentHeight: CGFloat? {
        didSet {
            presentedView?.needsUpdateConstraints()
            
            UIView.animate(withDuration: 0.3, animations: {
                self.presentedView?.frame = self.frameOfPresentedViewInContainerView
                self.presentedView?.layoutIfNeeded()
            })
        }
    }
    
    
    override init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?
    ) {
        super.init(presentedViewController: presentedViewController, presenting: presentedViewController)

        setupDimmingView()
    }
}


// MARK: - Computeds
extension DimmedModalPresentationController {
    private var parentViewSize: CGSize { containerView?.bounds.size ?? CGSize.zero }
    
    private var presentedViewSize: CGSize {
        if
            contentHeight == nil,
            let presentedViewController = presentedViewController as? ContentHeightProviding,
            let contentHeight = presentedViewController.contentHeight
        {
            return CGSize(width: parentViewSize.width * 0.85, height: contentHeight)
        } else {
            return size(forChildContentContainer: presentedViewController, withParentContainerSize: parentViewSize)
        }
    }
    
    private var presentedViewOriginX: CGFloat { (parentViewSize.width - presentedViewSize.width) / 2.0 }

    private var presentedViewOriginY: CGFloat {
        (parentViewSize.height - presentedViewSize.height - bottomOffset) / 2.0
    }
    
    private var presentedViewOrigin: CGPoint { CGPoint(x: presentedViewOriginX, y: presentedViewOriginY) }
}


// MARK: - UIPresentationController
extension DimmedModalPresentationController {
    override var shouldRemovePresentersView: Bool { false }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        showDimmingView(in: containerView)
    }
    
    
    override func dismissalTransitionWillBegin() {
        // 📝 Zap uses a nice pattern for having the presented view controller run
        // it's own animations here as well:
        // https://github.com/LN-Zap/zap-iOS/blob/915795b7d9/Library/Views/Modal/ModalPresentationController.swift#L79
        hideDimmingView()
    }
    
    
    // Reset the presented view’s frame to fit any changes to the `containerView` frame.
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    
    override func size(
        forChildContentContainer container: UIContentContainer,
        withParentContainerSize parentSize: CGSize
    ) -> CGSize {
        let height = contentHeight ?? parentSize.height * 0.75
        
        return CGSize(width: parentSize.width * 0.85, height: height)
    }
    
    
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: presentedViewOrigin, size: presentedViewSize)
    }
}


// MARK: - Event Handling
extension DimmedModalPresentationController {
    
    @objc func backgroundViewTapped(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}


// MARK: - Private Methods
private extension DimmedModalPresentationController {
    
    func setupDimmingView() {
        dimmingView = DimmedGradientView(frame: frameOfPresentedViewInContainerView)
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        
        dimmingView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(backgroundViewTapped(recognizer:))
            )
        )
    }

   
    func showDimmingView(in containerView: UIView) {
        containerView.insertSubview(dimmingView, at: 0)
        
        setDimmingViewConstraints(within: containerView)
        dimmingView.alpha = 0.0
        
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        transitionCoordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    
    func hideDimmingView() {
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        transitionCoordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    
    func setDimmingViewConstraints(within containerView: UIView) {
        NSLayoutConstraint.activate([
            dimmingView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            dimmingView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            dimmingView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dimmingView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}
