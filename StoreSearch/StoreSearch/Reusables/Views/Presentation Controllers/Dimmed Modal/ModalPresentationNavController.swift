//
//  DimmedModalPresentationNavController.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/29/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

final class DimmedModalPresentationNavController: UINavigationController {
    private var dimmedModalPresentationManager: DimmedModalPresentationManager?
    private var height: CGFloat?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    init(rootViewController: UIViewController, height: CGFloat? = nil) {
        super.init(rootViewController: rootViewController)
        
        setup()
        self.height = height
    }
}


// MARK: - Lifecycle
extension DimmedModalPresentationNavController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = Appearance.Constants.modalCornerRadius
        
        // 📝 An enhancement from here could be to allow for configuring whether or not
        // the modal was floating and centered or sliding up as a page sheet. For the latter style, we'd
        // only round the top two corners, like so...
//        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        tearDown()
        super.viewDidDisappear(true)
    }
}


// MARK: - ContentHeightProviding
extension DimmedModalPresentationNavController: ContentHeightProviding {
    var contentHeight: CGFloat? { height }
}


// MARK: - Private Helpers
private extension DimmedModalPresentationNavController {
    
    func setup() {
        dimmedModalPresentationManager = DimmedModalPresentationManager()
        transitioningDelegate = dimmedModalPresentationManager
        modalPresentationStyle = .custom
    }
    
    func tearDown() {
        dimmedModalPresentationManager = nil
        transitioningDelegate = nil
    }
}
