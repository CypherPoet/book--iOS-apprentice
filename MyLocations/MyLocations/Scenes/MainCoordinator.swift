//
//  MainCoordinator.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator {
    private let stateController: StateController
    
    private let tabBarController: UITabBarController
    private let currentLocationCoordinator: CurrentLocationCoordinator

    var rootViewController: UIViewController { tabBarController }
    
    
    init(stateController: StateController) {
        self.stateController = stateController
        self.tabBarController = UITabBarController()
        self.currentLocationCoordinator = CurrentLocationCoordinator(stateController: stateController)
    }
    
    
    func start() {
        let childCoordinators: [Coordinator] = [
            currentLocationCoordinator
        ]
    
        tabBarController.setViewControllers(
            childCoordinators.map { $0.rootViewController },
            animated: true
        )
    }
}
