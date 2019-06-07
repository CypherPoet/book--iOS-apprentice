//
//  ChecklistItemTableViewCell.swift
//  Checklists
//
//  Created by Brian Sipple on 6/7/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class ChecklistItemTableViewCell: UITableViewCell {
    @IBOutlet private weak var checkmarkImageView: UIImageView!
    @IBOutlet private weak var itemTitleLabel: UILabel!
    
    
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            configure(with: viewModel)
        }
    }
}


// MARK: - ViewModel

extension ChecklistItemTableViewCell {
    struct ViewModel {
        var isChecked: Bool
        var title: String
    }
}


// MARK: - Computeds

extension ChecklistItemTableViewCell {
    static var nib: UINib {
        return UINib(nibName: R.nib.checklistItemTableViewCell.name, bundle: nil)
    }
}


// MARK: - Private Helper Methods

private extension ChecklistItemTableViewCell {
    
    func configure(with viewModel: ViewModel) {
        checkmarkImageView?.isHidden = !viewModel.isChecked
        itemTitleLabel.text = viewModel.title
    }
}
