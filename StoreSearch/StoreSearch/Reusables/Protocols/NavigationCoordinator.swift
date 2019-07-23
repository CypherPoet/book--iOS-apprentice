//
//  NavigationCoordinator.swift
//  iOSReusables
//
//  Created by Brian Sipple on 6/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

protocol NavigationCoordinator: Coordinator, NavigationControlling {}

extension NavigationCoordinator {
    var rootViewController: UIViewController { navController }
}
