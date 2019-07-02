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
        case error(LocationDetectionError)
    }

    private var locationFetchTimer: Timer?
    
    
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
                case .error(let error):
                    self.mainView.viewModel.isFetchingLocation = false
                    self.mainView.viewModel.locationErrorMessage = error.message
                    self.mainView.viewModel.decodedAddress = nil
                    self.mainView.viewModel.currentLatitude = nil
                    self.mainView.viewModel.currentLongitude = nil
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
            guard let newReading = bestLocationReading else { return }
            DispatchQueue.main.async { self.bestLocationReadingSet(from: oldValue, to: newReading) }
        }
    }
}


extension CurrentLocationViewController {
    
    var locationAuthStatus: CLAuthorizationStatus {
        CLLocationManager.authorizationStatus()
    }
    

    var canTagLocation: Bool {
        switch currentLocationFetchState {
        case .inProgress:
            return false
        default:
            return bestLocationReading != nil
        }
    }
    
    
    /// Regardless of accuracy, if the coordinate from a new reading is not significantly different
    /// from the previous reading and it has been more than 10 seconds since
    /// we've received that original reading, we'll take it as a sign that
    /// we're sufficiently locked in.
    func shouldStop(afterReading newLocation: CLLocation, comparedTo previousLocation: CLLocation) -> Bool {
        let timeFromLast = newLocation.timestamp.timeIntervalSince(previousLocation.timestamp)
        let distanceFromLast = newLocation.distance(from: previousLocation)
        
        return distanceFromLast < 1 && timeFromLast > 10
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
        
        guard let error = error as? CLError else {
            currentLocationFetchState = .error(.misc)
            return
        }
        
        handle(locationManagerError: error)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocationReading = locations.last else { fatalError() }
        print("didUpdateLocations::lastLocation: \(newLocationReading)")
        
        guard
            newLocationReading.timestamp.timeIntervalSinceNow > -5,  // guard against old (cached and irrelevant) results.
            newLocationReading.horizontalAccuracy > 0  // guard against invalid results
        else { return }
        
        if
            bestLocationReading == nil ||
            newLocationReading.horizontalAccuracy < bestLocationReading!.horizontalAccuracy
        {
            // 🔑 Lower accuracy here means MORE accurate. We'll want to use that
            currentLocationFetchState = .found(newBest: newLocationReading)
        }
        
        guard let bestLocationReading = bestLocationReading else { return }
        
        if shouldStop(afterReading: newLocationReading, comparedTo: bestLocationReading) {
            print("Forcing stop")
            stopUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if !CLLocationManager.locationServicesEnabled() {
            currentLocationFetchState = .error(.servicesDisabled)
            stopUpdatingLocation()
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
            currentLocationFetchState = .error(.servicesDisabled)
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


// MARK: - Event Handling

extension CurrentLocationViewController {
    
    @objc func didTimeOutFetchingLocation() {
        currentLocationFetchState = .error(.timedOut)
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.stopUpdatingLocation()
        }
    }
}


// MARK: - Private Helpers

private extension CurrentLocationViewController {
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    
    func bestLocationReadingSet(from oldBest: CLLocation?, to newBest: CLLocation) {
        mainView.viewModel.isFetchingLocation = false
        mainView.viewModel.locationErrorMessage = nil
        mainView.viewModel.currentLatitude = newBest.coordinate.latitude
        mainView.viewModel.currentLongitude = newBest.coordinate.longitude
        
        currentAddressDecodingState = .unstarted
        
        if
            oldBest == nil ||
            newBest.horizontalAccuracy <= locationManager.desiredAccuracy // "equal to or better than desired"
        {
            print("Sufficient Location accuracy found: \(newBest.horizontalAccuracy)\n\t\t--Beginning to reverse geocode")
            reverseGeocode(location: newBest)
        }
    }

    
    func handle(locationManagerError error: CLError) {
        switch error.code {
        case .locationUnknown:
            currentLocationFetchState = .error(.locationUnknown)
        case .denied:
            currentLocationFetchState = .error(.servicesDisabled)
        default:
            currentLocationFetchState = .error(.misc)
        }
    }
    
    
    func startUpdatingLocation() {
        // assume that the current best is no longer relevant
        bestLocationReading = nil
        
        currentLocationFetchState = .inProgress
        
        locationFetchTimer = makeLocationFetchTimer()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    
    func stopUpdatingLocation() {
        switch currentLocationFetchState {
        case .found(let bestLocationReading):
            if case AddressDecodingState.finished = currentAddressDecodingState {
                break
            } else {
                // Make sure we always try to reverse-geocode at least once if we got any location readings
                reverseGeocode(location: bestLocationReading)
            }
        default:
            break
        }
        
        currentLocationFetchState = .stopped
        locationFetchTimer?.invalidate()
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
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
                    self.currentAddressDecodingState = .error(
                        message: "⚠️ No address could be determined from these coordinates."
                    )
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
    
    
    func makeLocationFetchTimer() -> Timer {
        return Timer.scheduledTimer(
            timeInterval: 60,
            target: self,
            selector: #selector(didTimeOutFetchingLocation),
            userInfo: nil,
            repeats: false
        )
    }
}
