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
    private let taggedLocationsCoordinator: TaggedLocationsCoordinator
    private let mapCoordinator: MapViewerCoordinator

    
    var rootViewController: UIViewController { tabBarController }
    
    
    init(stateController: StateController) {
        self.stateController = stateController
        self.tabBarController = UITabBarController()

        Appearance.apply(to: self.tabBarController.tabBar)
        
        self.currentLocationCoordinator = CurrentLocationCoordinator(stateController: stateController, tabBarIndex: 0)
        self.taggedLocationsCoordinator = TaggedLocationsCoordinator(stateController: stateController, tabBarIndex: 1)
        self.mapCoordinator = MapViewerCoordinator(stateController: stateController, tabBarIndex: 2)
    }
    
    
    func start() {
        let childCoordinators: [Coordinator] = [
            currentLocationCoordinator,
            taggedLocationsCoordinator,
            mapCoordinator,
        ]
    
        tabBarController.setViewControllers(
            childCoordinators.map { $0.rootViewController },
            animated: true
        )
        
    }
}
