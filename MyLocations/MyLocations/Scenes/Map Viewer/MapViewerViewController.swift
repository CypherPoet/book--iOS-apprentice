//
//  MapViewController.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/12/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import MapKit


protocol MapViewerViewControllerDelegate {
    func controller(_ controller: MapViewerViewController, didSelectDetailsFor annotation: MKAnnotation)
}


class MapViewerViewController: UIViewController, Storyboarded {
    @IBOutlet var mapViewerView: MapViewerView!
    
    var modelController: MapViewerModelController!
}


// MARK: - Lifecycle

extension MapViewerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(modelController != nil, "No model controller was set")
        
        mapViewerView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadLocations()
    }
}


// MARK: - Event Handling

extension MapViewerViewController {
    
    @IBAction func showUserTapped(_ button: UIBarButtonItem) {
        mapViewerView.setFocusToCurrentUser()
    }
    
    
    @IBAction func showLocationsTapped(_ button: UIBarButtonItem) {
        mapViewerView.setFocusToAnnotations()
    }
}


// MARK: - MapViewerViewDelegate

extension MapViewerViewController: MapViewerViewDelegate {
    
    func view(_ view: MapViewerView, didSelectDetailsFor annotation: MKAnnotation) {
        delegate?.controller(self, didSelectDetailsFor: annotation)
    }
    
}


// MARK: - Private Helpers

private extension MapViewerViewController {

    func loadLocations() {
        modelController.fetchLocations { [weak self] dataResult in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch dataResult {
                case .success(let locations):
                    self.mapViewerView.annotations = locations
                    
                    if !locations.isEmpty {
                        self.mapViewerView.setFocusToAnnotations()
                    }
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}
