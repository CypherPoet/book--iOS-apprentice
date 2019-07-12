//
//  MapViewController.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/12/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


class MapViewerViewController: UIViewController, Storyboarded {
    @IBOutlet var mainView: MapViewerView!
    
    var modelController: MapViewerModelController!
}


// MARK: - Lifecycle

extension MapViewerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(modelController != nil, "No model controller was set")
        
        loadLocations()
    }
}


// MARK: - Event Handling

extension MapViewerViewController {
    
    @IBAction func showUserTapped(_ button: UIBarButtonItem) {
        mainView.setFocusToCurrentUser()
    }
    
    
    @IBAction func showLocationsTapped(_ button: UIBarButtonItem) {
        mainView.setFocusToAnnotations()
    }
}


// MARK: - Private Helpers

private extension MapViewerViewController {

    func loadLocations() {
        modelController.fetchLocations { [weak self] dataResult in
            guard let self = self else { return }
            
            switch dataResult {
            case .success(let locations):
                self.mainView.annotations = locations
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}
