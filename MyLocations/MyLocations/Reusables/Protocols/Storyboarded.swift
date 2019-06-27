//
//  Storyboarded.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


protocol Storyboarded {
    static var storyboardID: String { get }
    
    static func instantiateFromStoryboard(named storyboardName: String) -> Self
}


extension Storyboarded where Self: UIViewController {

    // Returns the class name of the controller
    static var storyboardID: String { String(describing: self) }
    
    
    static func instantiateFromStoryboard(named storyboardName: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        
        guard
            let viewController = storyboard.instantiateViewController(withIdentifier: Self.storyboardID) as? Self
        else {
            preconditionFailure("Unable to find view controller with storyboard instantiation")
        }

        return viewController
    }
}
