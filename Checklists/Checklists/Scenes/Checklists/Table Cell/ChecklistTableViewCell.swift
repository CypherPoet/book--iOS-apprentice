//
//  ChecklistTableViewCell.swift
//  Checklists
//
//  Created by Brian Sipple on 6/13/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
    var viewModel: ViewModel! {
        didSet {
            guard let viewModel = viewModel else { return }
            render(with: viewModel)
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
    

    func render(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitleText
    }
    
}


// MARK: - View Model

extension ChecklistTableViewCell {
    
    struct ViewModel {
        var title: String
        var totalItemCount: Int
        var unfinishedItemCount: Int
        var iconName: UIImage?
        
        var subtitleText: String {
            if totalItemCount == 0 {
                return "(No Items)"
            } else {
                return unfinishedItemCount == 0 ? "All Done!" : "\(unfinishedItemCount) Remaining"
            }
        }
    }
}


extension ChecklistTableViewCell {
    static var nib: UINib {
        return UINib(nibName: R.nib.checklistTableViewCell.name, bundle: nil)
    }
}
