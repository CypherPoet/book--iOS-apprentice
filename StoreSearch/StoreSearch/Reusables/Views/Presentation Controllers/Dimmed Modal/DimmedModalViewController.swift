//
//  DimmedModalViewController.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/29/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class DimmedModalViewController: UIViewController {
    private var modalPresentationManager: DimmedModalPresentationManager?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}


// MARK: - Lifecycle
extension DimmedModalViewController {
    
    override func viewDidDisappear(_ animated: Bool) {
        modalPresentationManager = nil
        transitioningDelegate = nil
        
        super.viewDidDisappear(true)
    }
}


// MARK: - Private Helpers
private extension DimmedModalViewController {
    
    func setup() {
        modalPresentationManager = DimmedModalPresentationManager()
        transitioningDelegate = modalPresentationManager
        modalPresentationStyle = .custom
    }
}
