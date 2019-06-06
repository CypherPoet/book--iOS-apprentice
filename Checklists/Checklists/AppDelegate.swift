//
//  AppDelegate.swift
//  Checklists
//
//  Created by Brian Sipple on 6/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var checklistModelController = ChecklistItemsModelController()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        performInjections()
        
        return true
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}


// MARK: - Private Helper Methods

private extension AppDelegate {
    
    func performInjections() {
        guard
            let rootNavController = window?.rootViewController as? UINavigationController,
            let checklistListVC = rootNavController.topViewController as? ChecklistListViewController
        else {
            preconditionFailure("Unable to find expected view controllers")
        }
        
        checklistListVC.modelController = checklistModelController
    }
    
}
