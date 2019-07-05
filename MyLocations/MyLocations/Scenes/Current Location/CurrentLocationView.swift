//
//  CurrentLocationView.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


protocol CurrentLocationViewDelegate: class {
    func viewDidSelectFetchLocation(_ view: CurrentLocationView)
    func viewDidSelectStopLocationFetch(_ view: CurrentLocationView)
    func viewDidSelectTagLocation(_ view: CurrentLocationView)
}


class CurrentLocationView: UIView {
    @IBOutlet var locationReadingHeaderLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var tagLocationButton: UIButton!
    @IBOutlet var getLocationButton: UIButton!
    
    weak var delegate: CurrentLocationViewDelegate?
    
    var viewModel: ViewModel! {
        didSet {
            guard let viewModel = viewModel else { return }
            render(with: viewModel)
        }
    }
    
    var canTagLocation: Bool = false {
        didSet { tagLocationButton.isHidden = !canTagLocation }
    }
}



// MARK: - Event Handling

extension CurrentLocationView {

    @IBAction func getLocationTapped(_ sender: UIButton) {
        if viewModel.isFetchingLocation {
            delegate?.viewDidSelectStopLocationFetch(self)
        } else {
            delegate?.viewDidSelectFetchLocation(self)
        }
    }
    
    
    @IBAction func tagLocationTapped(_ sender: UIButton) {
        delegate?.viewDidSelectTagLocation(self)
    }
}



// MARK: - Private Helpers

private extension CurrentLocationView {
    
    func render(with viewModel: ViewModel) {
        latitudeLabel.text = viewModel.latitudeText
        longitudeLabel.text = viewModel.longitudeText
        addressLabel.text = viewModel.decodedAddressText
        
        locationReadingHeaderLabel.text = viewModel.locationReadingHeaderText
        
        getLocationButton.setTitle(viewModel.locationFetchButtonText, for: .normal)
    }
}
