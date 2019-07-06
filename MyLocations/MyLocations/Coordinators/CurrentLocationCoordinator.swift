//
//  TagLocationCoordinator.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation


// TODO: Place protocols in separate files

protocol CurrentLocationControllerDelegate: class {
    func viewController(
        _ controller: CurrentLocationViewController,
        didSelectTag location: CLLocation,
        at placemark: CLPlacemark?
    )
}


final class CurrentLocationCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    private let stateController: StateController
    
    private var tagLocationCoordinator: TagLocationCoordinator?
    
    
    init(
        navController: UINavigationController = UINavigationController(),
        stateController: StateController
    ) {
        self.navController = navController
        self.stateController = stateController
        
        start()
    }

    
    func start() {
        let currentLocationVC = CurrentLocationViewController.instantiateFromStoryboard(
            named: R.storyboard.currentLocation.name
        )
        
        currentLocationVC.delegate = self
        currentLocationVC.locationManager = stateController.locationManager
        currentLocationVC.tabBarItem = UITabBarItem(title: "Tag", image: UIImage(systemName: "tag.fill"), tag: 0)
        
        navController.navigationBar.prefersLargeTitles = false
        navController.navigationBar.isHidden = true
        navController.setViewControllers([currentLocationVC], animated: true)
    }
}


// MARK: - CurrentLocationControllerDelegate

extension CurrentLocationCoordinator: CurrentLocationControllerDelegate {
    
    func viewController(
        _ controller: CurrentLocationViewController,
        didSelectTag location: CLLocation,
        at placemark: CLPlacemark?
    ) {
        tagLocationCoordinator = TagLocationCoordinator(
            navController: navController,
            delegate: self,
            coordinate: location.coordinate,
            placemark: placemark
        )
        
        tagLocationCoordinator?.start()
    }
}



// MARK: - TagLocationCoordinatorDelegate

extension CurrentLocationCoordinator: TagLocationCoordinatorDelegate {
    
    func coordinator(_ coordinator: TagLocationCoordinator, didFinishTagging location: Location) {

        _ = HudIndicatorView.temporaryOverlay(
            covering: navController.view,
            labeled: "Tagged",
            withImage: UIImage(systemName: "checkmark"),
            animated: true,
            removeAfter: 0.76,
            onRemove: { [weak self] in
                guard let self = self else { return }
                self.navController.popViewController(animated: true)
            }
        )
    }
    
    
    func coordinatorDidCancel(_ coordinator: TagLocationCoordinator) {
        navController.popViewController(animated: true)
        navController.navigationBar.isHidden = true
    }
    
}
