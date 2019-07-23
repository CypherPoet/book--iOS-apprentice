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

    private var searchCoordinator: SearchCoordinator?
    

    init(window: UIWindow, navController: UINavigationController) {
        self.window = window
        self.navController = navController
    }
}


// MARK: - Coordinator

extension AppCoordinator: Coordinator {

    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        
        showSearch()
    }
}



// MARK: - Navigation

extension AppCoordinator {
    
    func showSearch() {
        searchCoordinator = SearchCoordinator(navController: navController)
        searchCoordinator?.start()
    }
}
