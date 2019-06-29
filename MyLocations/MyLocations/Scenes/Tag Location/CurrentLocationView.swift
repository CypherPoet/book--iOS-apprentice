//
//  CurrentLocationView.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


protocol CurrentLocationViewDelegate: class {
    func viewDidSelectGetLocation(_ view: CurrentLocationView)
}


class CurrentLocationView: UIView {
    @IBOutlet var locationStatusLabel: UILabel!
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
        delegate?.viewDidSelectGetLocation(self)
    }
}



// MARK: - Private Helpers

private extension CurrentLocationView {
    
    func render(with viewModel: ViewModel) {
        latitudeLabel.text = viewModel.latitudeText
        longitudeLabel.text = viewModel.longitudeText
        addressLabel.text = viewModel.currentAddressText
        locationStatusLabel.text = viewModel.locationStatusMessage
    }
}
