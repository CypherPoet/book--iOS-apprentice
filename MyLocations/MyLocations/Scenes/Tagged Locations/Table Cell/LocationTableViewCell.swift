//
//  LocationTableViewCell.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/9/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet private var locationNameLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var locationPhotoImageView: UIImageView!
    
    
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { self.render(with: viewModel) }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


// MARK: - Computeds

extension LocationTableViewCell {
    
    static var nib: UINib {
        .init(nibName: R.nib.locationTableViewCell.name, bundle: nil)
    }
}


// MARK: - Private Helpers

private extension LocationTableViewCell {
    
    func render(with viewModel: ViewModel) {
        locationNameLabel.text = viewModel.nameText
        addressLabel.text = viewModel.addressText
        locationPhotoImageView.image = viewModel.photoImage
    }
}
