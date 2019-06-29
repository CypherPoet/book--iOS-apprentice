//
//  AppCoordinator.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

final class AppCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    private let window: UIWindow
    private let stateController: StateController
    private var mainCoordinator: MainCoordinator?
    
    
    init(
        navController: UINavigationController,
        stateController: StateController,
        window: UIWindow
    ) {
        self.navController = navController
        self.stateController = stateController
        self.window = window
    }

    
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
       showMain()
    }
}


// MARK: - Navigation

extension AppCoordinator {
    
    func showMain() {
        mainCoordinator = MainCoordinator(stateController: stateController)
        
        navController.setViewControllers([mainCoordinator!.rootViewController], animated: true)
        navController.isNavigationBarHidden = true
        
        mainCoordinator?.start()
    }
}
