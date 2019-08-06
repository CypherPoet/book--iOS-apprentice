//
//  LoadingViewControllerToggling.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/6/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


protocol LoadingViewControllerToggling {
    associatedtype LoadingViewControllerType: UIViewController
    
    func showLoadingSpinner()
    func hideLoadingSpinner()
    
    var loadingVC: LoadingViewControllerType { get set }
}


extension Storyboarded where Self: LoadingViewControllerToggling, Self: UIViewController {
    func showLoadingSpinner() {
        add(child: loadingVC)
    }
    
    func hideLoadingSpinner() {
        loadingVC.performRemoval()
    }
}
