//
//  MapViewerView.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/12/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import MapKit


class MapViewerView: UIView {
    @IBOutlet private var mapView: MKMapView!
    

    var regionZoomLatitudinalMeters: CLLocationDistance = 1000
    var regionZoomLongitudinalMeters: CLLocationDistance = 1000
  
    var annotations: [MKAnnotation]? {
        didSet {
            guard let newAnnotations = annotations else { return }
            
            DispatchQueue.main.async {
                self.annotationsDidChange(from: oldValue, to: newAnnotations)
            }
        }
    }
    
//    var viewModel: ViewModel? {
//        didSet {
//            guard let viewModel = viewModel else { return }
//            DispatchQueue.main.async { self.render(with: viewModel) }
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mapView.delegate = self
    }
}


// MARK: - Computeds

extension MapViewerView {
    
    var currentUserCoordinate: CLLocationCoordinate2D { mapView.userLocation.coordinate }
    
    
    var currentUserRegion: MKCoordinateRegion {
        .init(
            center: currentUserCoordinate,
            latitudinalMeters: regionZoomLatitudinalMeters,
            longitudinalMeters: regionZoomLongitudinalMeters
        )
    }
    

    var regionBoundingAnnotations: MKCoordinateRegion {
        guard let annotations = annotations, !annotations.isEmpty else {
            return currentUserRegion
        }

        guard annotations.count > 1 else {
            return MKCoordinateRegion(
                center: annotations[0].coordinate,
                latitudinalMeters: regionZoomLatitudinalMeters,
                longitudinalMeters: regionZoomLatitudinalMeters
            )
        }
        
        let (boundingSpan, center) = MKCoordinateSpan.boundingMetrics(for: annotations)
        
        return MKCoordinateRegion(
            center: center,
            latitudinalMeters: boundingSpan.latitudeDelta * 1.1,
            longitudinalMeters: boundingSpan.longitudeDelta * 1.1
        )
    }
}


extension MapViewerView {
    
    func setFocusToCurrentUser() {
        mapView.setRegion(
            mapView.regionThatFits(currentUserRegion),
            animated: true
        )
    }
    
    
    func setFocusToAnnotations() {
        mapView.setRegion(
            mapView.regionThatFits(regionBoundingAnnotations),
            animated: true
        )
    }
    
}


// MARK: - MKMapViewDelegate

extension MapViewerView: MKMapViewDelegate {
    
}


// MARK: - Private Helpers

private extension MapViewerView {
    
    func render(with viewModel: ViewModel) {
        
    }
    
    
    func annotationsDidChange(
        from oldAnnotations: [MKAnnotation]?,
        to newAnnotations: [MKAnnotation]
    ) {
        if let oldAnnotations = oldAnnotations {
            mapView.removeAnnotations(oldAnnotations)
        }
        
        mapView.addAnnotations(newAnnotations)
//        
//        mapView.setRegion(
//            mapView.regionThatFits(regionBoundingAnnotations),
//            animated: true
//        )
    }
}
