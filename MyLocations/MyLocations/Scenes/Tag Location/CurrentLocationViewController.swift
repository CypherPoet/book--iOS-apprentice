//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation



class CurrentLocationViewController: UIViewController, Storyboarded {
    @IBOutlet var mainView: CurrentLocationView!
    
    var locationManager: CLLocationManager!
    
    private var currentLocation: CLLocation? {
        didSet {
            DispatchQueue.main.async { self.currentLocationChanged() }
        }
    }
    
    
    private var lastLocationError: Error? {
        didSet {
            DispatchQueue.main.async { self.lastLocationErrorChanged() }
        }
    }
    
    
    private var isLocationServicesEnabled: Bool = false {
        didSet {
            if !isLocationServicesEnabled {
                DispatchQueue.main.async {
                    self.mainView.viewModel.locationErrorMessage = "Location Services Disabled"
                    self.stopUpdatingLocation()
                }
            }
        }
    }
}


extension CurrentLocationViewController {
    
    var locationAuthStatus: CLAuthorizationStatus {
        CLLocationManager.authorizationStatus()
    }
    
    var canTagLocation: Bool { currentLocation != nil }
}


// MARK: - Lifecycle

extension CurrentLocationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Current Location"
        
        mainView.delegate = self
        mainView.viewModel = .init()
        
        currentLocation = nil
        setupLocationManager()
    }
}


// MARK: - CLLocationManagerDelegate

extension CurrentLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager::didFailWithError: \(error.localizedDescription)")
        lastLocationError = error
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations::lastLocation: \(locations.last!)")
        lastLocationError = nil
        currentLocation = locations.last
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        isLocationServicesEnabled = CLLocationManager.locationServicesEnabled()
    }
    
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        stopUpdatingLocation()
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        startUpdatingLocation()
    }
}


// MARK: - CurrentLocationViewDelegate

extension CurrentLocationViewController: CurrentLocationViewDelegate {
    
    func viewDidSelectGetLocation(_ view: CurrentLocationView) {
        switch locationAuthStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            isLocationServicesEnabled = false
            showLocationServicesDeniedAlert()
        case .authorizedAlways, .authorizedWhenInUse:
            startUpdatingLocation()
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
}


private extension CurrentLocationViewController {
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        isLocationServicesEnabled = CLLocationManager.locationServicesEnabled()
    }
    
    
    func currentLocationChanged() {
        mainView.viewModel.currentLatitude = currentLocation?.coordinate.latitude
        mainView.viewModel.currentLongitude = currentLocation?.coordinate.longitude
        
        mainView.canTagLocation = canTagLocation
    }
    
    
    func lastLocationErrorChanged() {
        switch lastLocationError {
        case .none:
            mainView.viewModel.locationErrorMessage = nil
        case (let clError as CLError):
            switch clError.code {
            case .locationUnknown:
                break
            case .denied:
                isLocationServicesEnabled = false
            default:
                mainView.viewModel.locationErrorMessage = "Error Getting Location"
            }
        default:
            break
//            mainView.viewModel.locationErrorMessage = nil
        }
    }
    
    
    func startUpdatingLocation() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()

        mainView.viewModel.isFetchingLocation = true
    }
    
    
    func stopUpdatingLocation() {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()

        mainView.viewModel.isFetchingLocation = false
    }
}
