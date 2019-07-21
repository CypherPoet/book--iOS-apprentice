//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation


protocol CurrentLocationViewControllerDelegate: class {
    func viewController(
        _ controller: CurrentLocationViewController,
        didSelectTag location: CLLocation,
        at placemark: CLPlacemark?
    )
}


class CurrentLocationViewController: UIViewController, Storyboarded {
    @IBOutlet var mainView: CurrentLocationView!
    
    weak var delegate: CurrentLocationViewControllerDelegate?
    var locationManager: CLLocationManager!
    var geocodingService: GeocodingService = GeocodingService()
    
    enum AddressDecodingState {
        case unstarted
        case stopped
        case inProgress
        case finished(CLPlacemark)
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
                    self.mainView.viewModel.currentPlacemark = nil
                    self.mainView.viewModel.decodedAddressErrorMessage = nil
                case .stopped:
                    self.mainView.viewModel.isDecodingAddress = false
                case .error(let message):
                    self.mainView.viewModel.isDecodingAddress = false
                    self.mainView.viewModel.decodedAddressErrorMessage = message
                case .finished(let placemark):
                    self.mainView.viewModel.isDecodingAddress = false
                    self.mainView.viewModel.currentPlacemark = placemark
                    self.mainView.viewModel.decodedAddressErrorMessage = nil
                case .inProgress:
                    self.mainView.viewModel.isDecodingAddress = true
                    self.mainView.viewModel.currentPlacemark = nil
                    self.mainView.viewModel.decodedAddressErrorMessage = nil
                }

                self.mainView.canTagLocation = self.canTagLocation
                self.mainView.canShowCoordinates = self.canShowCoordinates
                self.mainView.canShowAddress = self.canShowAddress
            }
        }
    }
    
    
    private var currentLocationFetchState: LocationFetchState = .unstarted {
        didSet {
            DispatchQueue.main.async {
                switch self.currentLocationFetchState {
                case .unstarted:
                    self.mainView.viewModel.isFetchingLocation = false
                    self.mainView.viewModel.currentLocation = nil
                case .stopped:
                    self.mainView.viewModel.isFetchingLocation = false
                case .error(let error):
                    self.mainView.viewModel.isFetchingLocation = false
                    self.mainView.viewModel.locationErrorMessage = error.message
                    self.mainView.viewModel.currentLocation = nil
                    self.currentAddressDecodingState = .stopped
                case .found(let newBest):
                    self.mainView.viewModel.isFetchingLocation = false
                    self.mainView.viewModel.locationErrorMessage = nil
                    self.mainView.viewModel.currentLocation = newBest
                    self.bestLocationReading = newBest
                case .inProgress:
                    self.mainView.viewModel.isFetchingLocation = true
                    self.mainView.viewModel.locationErrorMessage = nil
                }
                
                self.mainView.canTagLocation = self.canTagLocation
                self.mainView.canShowCoordinates = self.canShowCoordinates
                self.mainView.canShowAddress = self.canShowAddress
                self.mainView.shouldShowFetchingSpinner = self.mainView.viewModel.isFetchingLocation
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


// MARK: - Computeds

extension CurrentLocationViewController {
    
    var locationAuthStatus: CLAuthorizationStatus { CLLocationManager.authorizationStatus() }
    
    var canShowCoordinates: Bool {
        switch currentLocationFetchState {
        case .found:
            return true
        case .stopped:
            return mainView.viewModel.currentLocation != nil
        default:
            return false
        }
    }

    
    var canTagLocation: Bool {
        switch currentAddressDecodingState {
        case .inProgress:
            return false
        default:
            return canShowCoordinates
        }
    }
    
    
    var canShowAddress: Bool {
        switch currentAddressDecodingState {
        case .finished:
            return true
        default:
            return false
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

        mainView.delegate = self
        mainView.viewModel = .init()
        
        currentLocationFetchState = .unstarted
        currentAddressDecodingState = .unstarted
        
        setupLocationManager()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopUpdatingLocation()
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
            // ❓ When would this happen?
            currentLocationFetchState = .unstarted
            currentAddressDecodingState = .unstarted
        }
    }
}


// MARK: - CurrentLocationViewDelegate

extension CurrentLocationViewController: CurrentLocationViewDelegate {
    
    func viewDidSelectTagLocation(_ view: CurrentLocationView) {
        guard let location = view.viewModel.currentLocation else {
            preconditionFailure("Tag Location selected without required information")
        }
        
        let placemark = view.viewModel.currentPlacemark
        delegate?.viewController(self, didSelectTag: location, at: placemark)
    }
    
    
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
        if oldBest == nil || newBest.horizontalAccuracy <= locationManager.desiredAccuracy {
            // lower accuracy means more precise here
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
        currentAddressDecodingState = .unstarted
        currentLocationFetchState = .inProgress
        
        locationFetchTimer = makeLocationFetchTimer()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    
    func stopUpdatingLocation() {
        switch currentLocationFetchState {
        case .found(let bestLocationReading):
            switch currentAddressDecodingState {
            case .finished: break
            default:
                // Make sure we always try to reverse-geocode at least once if we got any location readings
                reverseGeocode(location: bestLocationReading)
            }
        default: break
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
                    self.currentAddressDecodingState = .finished(placemark)
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
