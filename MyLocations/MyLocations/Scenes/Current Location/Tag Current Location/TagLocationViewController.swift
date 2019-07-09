//
//  TagLocationViewController.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData


class TagLocationViewController: UITableViewController, Storyboarded {
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var latitudeLabel: UILabel!
    @IBOutlet private var longitudeLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var descriptionCell: UITableViewCell!
    
    private lazy var descriptionTextView: UITextView = makeDescriptionTextView()
    
    private enum CellIndexPath {
        static let category: (row: Int, section: Int) = (0, 1)
    }
    
    var viewModel: TagLocationViewModel!
    var manageObjectContext: NSManagedObjectContext!
    weak var delegate: TagLocationViewControllerDelegate?
}


// MARK: - Computeds

extension TagLocationViewController {
    
    var locationFromChanges: Location {
        let location = Location(context: manageObjectContext)
        
        location.latitude = viewModel.coordinate.latitude
        location.longitude = viewModel.coordinate.latitude
        location.category = viewModel.category ?? .none
        location.dateRecorded = viewModel.dateRecorded
        location.placemark = viewModel.placemark
        location.locationDescription = viewModel.locationDescription
        
        return location
    }
    
}

// MARK: - Lifecycle

extension TagLocationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(viewModel != nil, "No `viewModel` was set")
        assert(manageObjectContext != nil, "No `manageObjectContext` was set")
        
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        render(with: viewModel)
    }
}


// MARK: - UITableViewDelegate

extension TagLocationViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row, indexPath.section) {
        case (CellIndexPath.category.row, CellIndexPath.category.section):
            delegate?.viewControllerDidSelectChooseCategory(self)
        default:
            break
        }
    }
}


// MARK: - Event Handling

extension TagLocationViewController {
    
    @IBAction func cancelTapped() {
        delegate?.viewControllerDidCancel(self)
    }
    
    
    @IBAction func doneButtonTapped() {
        print("Done button tapped")
        delegate?.viewController(self, didSave: locationFromChanges)
    }
    
    
    @IBAction func tableViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        potentiallyHideKeyboardOnTap(from: gestureRecognizer)
    }
}


// MARK: - UITextViewDelegate

extension TagLocationViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.locationDescription = textView.text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel.locationDescription = textView.text
    }
}


// MARK: - Private Helpers

private extension TagLocationViewController {

    func setupUI() {
        descriptionCell.addSubview(descriptionTextView)
        
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
        categoryLabel.text = viewModel.categoryLabelText
        addressLabel.text = viewModel.addressText
        dateLabel.text = viewModel.dateText
    }
    
    
    func makeDescriptionTextView() -> UITextView {
        let textView = UITextView()
        
        textView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)

        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }
    
    
    func potentiallyHideKeyboardOnTap(from gestureRecognizer: UIGestureRecognizer) {
        let pointTouched = gestureRecognizer.location(in: tableView)
        
        if !descriptionCell.point(inside: pointTouched, with: nil) {
            descriptionTextView.resignFirstResponder()
        }
    }
}
