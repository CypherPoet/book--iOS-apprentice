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
    @IBOutlet private var locationReadingHeaderLabel: UILabel!
    @IBOutlet private var latitudeLabel: UILabel!
    @IBOutlet private var longitudeLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var tagLocationButton: UIButton!
    @IBOutlet private var getLocationButton: UIButton!
    @IBOutlet private var coordinatesContainerView: UIStackView!
    
    
    weak var delegate: CurrentLocationViewDelegate?
    
    var viewModel: ViewModel! {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { self.render(with: viewModel) }
        }
    }
    
    var canTagLocation: Bool = false {
        didSet { animateVisibility(for: tagLocationButton, isShowing: canTagLocation) }
    }
    
    var canShowCoordinates: Bool = false {
        didSet { animateVisibility(for: coordinatesContainerView, isShowing: canShowCoordinates) }
    }
    
    var canShowAddress: Bool = false {
        didSet { animateVisibility(for: addressLabel, isShowing: canShowAddress) }
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
    
    
    func animateVisibility(for view: UIView, isShowing: Bool) {
        DispatchQueue.main.async {
            view.isHidden = !isShowing

            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: [.curveEaseInOut],
                animations: {
                    view.alpha = isShowing ? 1 : 0.0
                }
            )
        }
    }
}
