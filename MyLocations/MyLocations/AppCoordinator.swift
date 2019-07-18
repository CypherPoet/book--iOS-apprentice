//
//  AppCoordinator.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


final class AppCoordinator: NavigationCoordinator {
    private let window: UIWindow
    var navController: UINavigationController
    private let stateController: StateController
    
    private var mainCoordinator: MainCoordinator?
    
    
    init(
        window: UIWindow,
        navController: UINavigationController,
        stateController: StateController
    ) {
        self.window = window
        self.navController = navController
        self.stateController = stateController
        
        registerForNoticiations()
    }

    
    func start() {
        window.rootViewController = rootViewController
        Appearance.apply(to: window)
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


// MARK: Private Helpers

private extension AppCoordinator {
    
    func registerForNoticiations() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(coreDataSaveFailed),
            name: .CoreDataSaveFailed,
            object: nil
        )
    }
    
    
    @objc func coreDataSaveFailed() {
        let alertTitle = "🙈 Internal Error"
        
        let alertMessage = """
                    There was a fatal error in the app and it cannot continue. Press "OK" to terminate it.

                    If the problem persists, please try to uninstall and reinstall \
                    the application on your deivce. Sorry for the inconvinience.
                    """
        
        let alertConfirmationAction = { (action: UIAlertAction) -> Void in
            let exception = NSException(
                name: .internalInconsistencyException,
                reason: "Fatal Core Data Error",
                userInfo: nil
            )
            
            exception.raise()
        }
        
        rootViewController.display(
            alertMessage: alertMessage,
            titled: alertTitle,
            confirmationHandler: alertConfirmationAction
        )
    }
}
