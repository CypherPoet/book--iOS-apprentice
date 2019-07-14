//
//  MapViewController.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/12/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import MapKit
import CoreData


protocol MapViewerViewControllerDelegate: class {
    func controller(_ controller: MapViewerViewController, didSelectEditingFor location: Location)
}


class MapViewerViewController: UIViewController, Storyboarded {
    @IBOutlet var mapViewerView: MapViewerView!
    
    var managedObjectContext: NSManagedObjectContext!
    var modelController: MapViewerModelController!
    weak var delegate: MapViewerViewControllerDelegate?
}


// MARK: - Lifecycle

extension MapViewerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(modelController != nil, "No model controller was set")
        assert(managedObjectContext != nil, "No managedObjectContext was set")
        
        mapViewerView.delegate = self
        
        loadLocations()
        setupObservers()
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
        guard let location = annotation as? Location else {
            preconditionFailure("Unexpected annotation type")
        }
        
        delegate?.controller(self, didSelectEditingFor: location)
    }
    
}


// MARK: - Private Helpers

private extension MapViewerViewController {

    @objc func loadLocations() {
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
    
    
    func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadLocations),
            name: .NSManagedObjectContextObjectsDidChange,
            object: managedObjectContext
        )
    }
}
