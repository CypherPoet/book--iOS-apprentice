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
    var geocodingService: GeocodingService = GeocodingService()
    
    enum AddressDecodingState {
        case unstarted
        case inProgress
        case finished(result: String?)
        case error(message: String)
    }
    
    enum LocationFetchState {
        case unstarted
        case stopped
        case inProgress
        case found(newBest: CLLocation)
        case error(message: String)
        case servicesDisabled
    }

    
    private var currentAddressDecodingState: AddressDecodingState = .unstarted {
        didSet {
            DispatchQueue.main.async {
                switch self.currentAddressDecodingState {
                case .unstarted:
                    self.mainView.viewModel.isDecodingAddress = false
                    self.mainView.viewModel.decodedAddress = nil
                    self.mainView.viewModel.decodedAddressErrorMessage = nil
                case .error(let message):
                    self.mainView.viewModel.isDecodingAddress = false
                    self.mainView.viewModel.decodedAddressErrorMessage = message
                case .finished(let result):
                    self.mainView.viewModel.isDecodingAddress = false
                    self.mainView.viewModel.decodedAddress = result
                    self.mainView.viewModel.decodedAddressErrorMessage = nil
                case .inProgress:
                    self.mainView.viewModel.isDecodingAddress = true
                    self.mainView.viewModel.decodedAddress = nil
                    self.mainView.viewModel.decodedAddressErrorMessage = nil
                }
            }
        }
    }
    
    
    private var currentLocationFetchState: LocationFetchState = .unstarted {
        didSet {
            DispatchQueue.main.async {
                switch self.currentLocationFetchState {
                case .unstarted:
                    self.mainView.viewModel.isFetchingLocation = false
                    self.mainView.viewModel.currentLatitude = nil
                    self.mainView.viewModel.currentLongitude = nil
                case .stopped:
                    self.mainView.viewModel.isFetchingLocation = false
                case .error(let message):
                    self.mainView.viewModel.isFetchingLocation = false
                    self.mainView.viewModel.locationErrorMessage = message
                    self.mainView.viewModel.decodedAddress = nil
                    self.mainView.viewModel.currentLatitude = nil
                    self.mainView.viewModel.currentLongitude = nil
                case .servicesDisabled:
                    self.mainView.viewModel.isFetchingLocation = false
                    self.mainView.viewModel.locationErrorMessage = "Location Service Disabled"
                    self.stopUpdatingLocation()
                case .found(let newBest):
                    self.bestLocationReading = newBest
                case .inProgress:
                    self.mainView.viewModel.isFetchingLocation = true
                    self.mainView.viewModel.locationErrorMessage = nil
                }
                
                self.mainView.canTagLocation = self.canTagLocation
            }
        }
    }
    

    private var bestLocationReading: CLLocation? {
        didSet {
            DispatchQueue.main.async { self.bestLocationReadingChanged(from: oldValue, to: self.bestLocationReading) }
        }
    }
}


extension CurrentLocationViewController {
    
    var locationAuthStatus: CLAuthorizationStatus {
        CLLocationManager.authorizationStatus()
    }
    

    var canTagLocation: Bool {
        switch currentLocationFetchState {
        case .found:
            return true
        default:
            return false
        }
    }
}


// MARK: - Lifecycle

extension CurrentLocationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Current Location"
        
        mainView.delegate = self
        mainView.viewModel = .init()
        
        currentLocationFetchState = .unstarted
        currentAddressDecodingState = .unstarted
        
        setupLocationManager()
    }
}


// MARK: - CLLocationManagerDelegate

extension CurrentLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager::didFailWithError: \(error.localizedDescription)")
        handle(locationManagerError: error)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { fatalError() }
        print("didUpdateLocations::lastLocation: \(newLocation)")
        
        guard
            newLocation.timestamp.timeIntervalSinceNow > -5,  // guard against old (cached and irrelevant) results.
            newLocation.horizontalAccuracy > 0  // guard against invalid results
        else { return }
        
        if bestLocationReading == nil || newLocation.horizontalAccuracy < bestLocationReading!.horizontalAccuracy {
            // 🔑 Lower accuracy here means MORE accurate. We'll want to use that
            currentLocationFetchState = .found(newBest: newLocation)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if !CLLocationManager.locationServicesEnabled() {
            currentLocationFetchState = .servicesDisabled
        } else {
            // TODO: When would this happen?
            currentLocationFetchState = .unstarted
        }
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
    
    func viewDidSelectFetchLocation(_ view: CurrentLocationView) {
        switch locationAuthStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            currentLocationFetchState = .servicesDisabled
            showLocationServicesDeniedAlert()
        case .authorizedAlways, .authorizedWhenInUse:
            startUpdatingLocation()
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    func viewDidSelectStopLocationFetch(_ view: CurrentLocationView) {
        stopUpdatingLocation()
    }
}


private extension CurrentLocationViewController {
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    
    func bestLocationReadingChanged(from oldBest: CLLocation?, to newBest: CLLocation?) {
        mainView.viewModel.isFetchingLocation = false
        mainView.viewModel.locationErrorMessage = nil
        mainView.viewModel.currentLatitude = newBest?.coordinate.latitude
        mainView.viewModel.currentLongitude = newBest?.coordinate.longitude
        
        currentAddressDecodingState = .unstarted
        
        guard let newLocationReading = newBest else {
            mainView.canTagLocation = false
            return
        }

        mainView.canTagLocation = true

        if
            oldBest == nil ||
            newLocationReading.horizontalAccuracy <= locationManager.desiredAccuracy // "equal to or better than desired"
        {
            print("Sufficient Location accuracy found: \(newLocationReading.horizontalAccuracy)\n\t\t--Stopping Location Manager")
            reverseGeocode(location: newLocationReading)
        }
    }

    
    
    func handle(locationManagerError error: Error) {
        switch error {
        case (let clError as CLError):
            switch clError.code {
            case .locationUnknown:
                currentLocationFetchState = .error(message: "Unable to Determine Location")
            case .denied:
                currentLocationFetchState = .servicesDisabled
            default:
                currentLocationFetchState = .error(message: "Error Getting Location")
            }
        default:
            break
        }
    }
    
    
    func startUpdatingLocation() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()

        currentLocationFetchState = .inProgress
    }
    
    
    func stopUpdatingLocation() {
        switch currentLocationFetchState {
        case .found(let bestLocationReading):
            // Make sure we always try to reverse-geocode at least once if we got any location readings
            switch currentAddressDecodingState {
            case .finished:
                break
            default:
                reverseGeocode(location: bestLocationReading)
            }
        default:
            break
        }
        
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()

        currentLocationFetchState = .stopped
    }
    
    
    func reverseGeocode(location: CLLocation) {
        currentAddressDecodingState = .inProgress
        
        geocodingService.reverseGeocode(location) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let placemark):
                    self.currentAddressDecodingState = .finished(result: placemark.multilineFormattedAddress)
                case .failure(.noPlacemarks):
                    self.currentAddressDecodingState = .error(message: "⚠️ No address could be determined from these coordinates.")
                case .failure(.coreLocationError):
                    self.currentAddressDecodingState = .error(
                        message: """
                            An error occurred while attempting to find an address for these
                            coordinates.
                            """
                    )
                }
            }
        }
    }
}
