//
//  AppDelegate.swift
//  Checklists
//
//  Created by Brian Sipple on 6/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private lazy var stateController = StateController()
    private lazy var checklistModelController = ChecklistModelController(stateController: stateController)
    
    private lazy var notificationCenter = UNUserNotificationCenter.current()
}


// MARK: - Lifecycle

extension AppDelegate {
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return true
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        performInjections()
        setupNotifications()
        
        return true
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    
    func applicationDidEnterBackground(_ application: UIApplication) {
        checklistModelController.saveChecklistData()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
        checklistModelController.saveChecklistData()
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
        
        checklistListVC.stateController = stateController
        checklistListVC.modelController = checklistModelController
    }
    
    
    func setupNotifications() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (wasGranted, error) in
            guard error == nil else {
                print("Error while requesting notification authorization:\n\n\(error!.localizedDescription)")
                return
            }
            
            print("Notification permission \(wasGranted ? "granted" : "denied")")
        }
        
        notificationCenter.add(CustomNotification.sample.request)
    }
}
