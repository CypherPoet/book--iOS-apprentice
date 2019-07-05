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
    
    private enum CellIndexPath {
        static let category: (section: Int, row: Int) = (1, 0)
    }
    
    var viewModel: TagLocationViewModel!
    weak var delegate: TagLocationViewControllerDelegate?
}


// MARK: - Lifecycle

extension TagLocationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(viewModel != nil, "No viewModel was set")
        
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
        switch (indexPath.section, indexPath.row) {
        case (CellIndexPath.category.section, CellIndexPath.category.row):
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
        categoryLabel.text = viewModel.categoryLabelText
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
