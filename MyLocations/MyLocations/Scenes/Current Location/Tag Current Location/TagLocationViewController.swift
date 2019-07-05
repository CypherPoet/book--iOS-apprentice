//
//  TagLocationViewController.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation


class TagLocationViewController: UITableViewController, Storyboarded {
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var latitudeLabel: UILabel!
    @IBOutlet private var longitudeLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var descriptionCell: UITableViewCell!

    private lazy var descriptionTextView: UITextView = makeDescriptionTextView()
    
    var viewModel: TagLocationViewModel!
    weak var delegate: TagLocationViewControllerDelegate?
}


// MARK: - Lifecycle

extension TagLocationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(viewModel != nil, "No viewModel was set")
        
        setupUI()
        render(with: viewModel)
    }
}


// MARK: - Event Handling

extension TagLocationViewController {
    
    @IBAction func cancelTapped() {
        delegate?.viewControllerDidCancel(self)
    }
    
    @IBAction func doneButtonTapped() {
        print("Done button tapped")
    }
}


// MARK: - Private Helpers

private extension TagLocationViewController {

    func setupUI() {
        descriptionCell.addSubview(descriptionTextView)

        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionTextView.leftAnchor.constraint(equalTo: descriptionCell.leftAnchor, constant: 0),
            descriptionTextView.topAnchor.constraint(equalTo: descriptionCell.topAnchor, constant: 0),
            descriptionTextView.rightAnchor.constraint(equalTo: descriptionCell.rightAnchor, constant: 0),
            descriptionTextView.bottomAnchor.constraint(equalTo: descriptionCell.bottomAnchor, constant: 0),
        ])
    }
    
    
    func render(with viewModel: TagLocationViewModel) {
        latitudeLabel.text = viewModel.latitudeText
        longitudeLabel.text = viewModel.longitudeText
        addressLabel.text = viewModel.addressText
        dateLabel.text = viewModel.dateText
    }
    
    
    func makeDescriptionTextView() -> UITextView {
        let textView = UITextView()
        
        textView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        
        return textView
    }
}
