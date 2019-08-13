//
//  AppCoordinator.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/22/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

final class AppCoordinator: NavigationCoordinator {
    private let window: UIWindow
    var navController: UINavigationController
//    private let stateController: StateController

//    private var searchCoordinator: SearchCoordinator?
    private var searchSplitViewCoordinator: SearchSplitViewCoordinator?
    private var searchSplitViewController: UISplitViewController

    
    init(window: UIWindow, navController: UINavigationController) {
        self.window = window
        self.navController = navController
        
        self.searchSplitViewController = UISplitViewController()
    }
}


// MARK: - Coordinator

extension AppCoordinator: Coordinator {
//
//    var rootViewController: UIViewController {
//        // TODO: Determine if we're always using the split view controller here,
//        // or if the nav controller might sometimes be the root.
//        searchSplitViewCoordinator?.rootViewController ?? navController
//    }
    
    
    func start() {
        window.makeKeyAndVisible()
        
//        showSearch()
        showSplitViewSearch()
    }
}



// MARK: - Navigation

extension AppCoordinator {
//    
//    func showSearch() {
//        window.rootViewController = rootViewController
//        
//        searchCoordinator = SearchCoordinator(navController: navController)
//        searchCoordinator?.start()
//    }
    
    
    func showSplitViewSearch() {
        searchSplitViewCoordinator = SearchSplitViewCoordinator(
            window: window
        )
        
        searchSplitViewCoordinator?.start()
    }
}
