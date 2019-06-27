//
//  Coordinator.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var rootViewController: UIViewController { get }
    
    func start()
}
