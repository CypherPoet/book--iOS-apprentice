//
//  MapViewerView.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/12/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import MapKit


protocol MapViewerViewDelegate: class {
    func view(_ view: MapViewerView, didSelectDetailsFor annotation: MKAnnotation)
}


class MapViewerView: UIView {
    @IBOutlet private var mapView: MKMapView!
    
    var regionZoomLatitudinalMeters: CLLocationDistance = 1000
    var regionZoomLongitudinalMeters: CLLocationDistance = 1000

    weak var delegate: MapViewerViewDelegate?
    
    var annotations: [CustomAnnotation] = [] {
        didSet {
            DispatchQueue.main.async {
                self.annotationsDidChange(from: oldValue, to: self.annotations)
            }
        }
    }

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
        guard !annotations.isEmpty else {
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
            span: MKCoordinateSpan(
                latitudeDelta: min(boundingSpan.latitudeDelta * 1.5, 180.0),
                longitudeDelta: min(boundingSpan.longitudeDelta * 1.5, 360.0)
            )
        )
    }
}


// MARK: - Core Methods

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
    
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        guard annotation is CustomAnnotation else { return nil }
        
        let annotationView = mapView
            .dequeueReusableAnnotationView(
                withIdentifier: CustomAnnotationViewFactory.reuseIdentifier
            ) as? MKPinAnnotationView ??
            CustomAnnotationViewFactory.makePinView(for: annotation)
        
        configure(annotationView, with: annotation)
        
        return annotationView
    }
    
    
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        guard
            view is MKPinAnnotationView,
            let annotation = view.annotation as? CustomAnnotation,
            (annotations as NSArray).contains(annotation)
        else { return }
        
        delegate?.view(self, didSelectDetailsFor: annotation)
    }
}


// MARK: - Private Helpers

private extension MapViewerView {
    
    func render(with viewModel: ViewModel) {
        
    }
    
    
    func annotationsDidChange(
        from oldAnnotations: [CustomAnnotation],
        to newAnnotations: [CustomAnnotation]
    ) {
        mapView.removeAnnotations(oldAnnotations)
        mapView.addAnnotations(newAnnotations)
    }
    
    
    func configure(_ pinAnnotationView: MKPinAnnotationView, with annotation: MKAnnotation) {
//        guard let rightButton = pinAnnotationView.rightCalloutAccessoryView as? UIButton else {
//            preconditionFailure("No button found for rightCalloutAccessoryView")
//        }
        
        pinAnnotationView.annotation = annotation
    }
}
