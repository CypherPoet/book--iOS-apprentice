//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation


class LocationDetailsViewController: UITableViewController, Storyboarded {
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var latitudeLabel: UILabel!
    @IBOutlet private var longitudeLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    
    var viewModel: LocationDetailsViewModel!
    weak var delegate: LocationDetailsViewControllerDelegate?
}


// MARK: - Lifecycle

extension LocationDetailsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(viewModel != nil, "No viewModel was set")
        
        render(with: viewModel)
    }
}


// MARK: - Event Handling

extension LocationDetailsViewController {
    
    @IBAction func cancelTapped() {
        delegate?.viewControllerDidCancel(self)
    }
    
    @IBAction func doneButtonTapped() {
        print("Done button tapped")
    }
}


// MARK: - Private Helpers

private extension LocationDetailsViewController {
    
    func render(with viewModel: LocationDetailsViewModel) {
        latitudeLabel.text = viewModel.latitudeText
        longitudeLabel.text = viewModel.longitudeText
        addressLabel.text = viewModel.addressText
        dateLabel.text = viewModel.dateText
    }
}
