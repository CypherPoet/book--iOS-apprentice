//
//  TagLocationViewController.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import CoreLocation


protocol TagLocationViewControllerDelegate: class {
    func viewControllerDidCancel(_ controller: TagLocationViewController)
    func viewControllerDidSaveLocation(_ controller: TagLocationViewController)
    func viewControllerDidSelectChooseCategory(_ controller: TagLocationViewController)
}


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
    var modelController: TagLocationModelController!
    weak var delegate: TagLocationViewControllerDelegate?
}


// MARK: - Computeds

extension TagLocationViewController {
    
    var locationModelChanges: TagLocationModelController.Changes {
        return (
            latitude: viewModel.latitude,
            longitude: viewModel.longitude,
            category: viewModel.category ?? .none,
            dateRecorded: viewModel.dateRecorded,
            placemark: viewModel.placemark,
            locationDescription: viewModel.locationDescription
        )
    }
}

// MARK: - Lifecycle

extension TagLocationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(viewModel != nil, "No `viewModel` was set")
        assert(modelController != nil, "No `modelController` was set")
        
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
        modelController.saveLocation(with: locationModelChanges) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success:
                    self.delegate?.viewControllerDidSaveLocation(self)
                case .failure(let error):
                    self.fatalCoreDataError(error)
                }
            }
        }
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
        descriptionTextView.text = viewModel.locationDescription
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


extension TagLocationViewController: CoreDataErrorHandling {}
