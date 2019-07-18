//
//  LocationTableHeaderView.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/17/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


final class LocationTableHeaderView: UIView {
    @IBOutlet private var titleLabel: UILabel!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        backgroundColor = UIColor.Theme.background?.withAlphaComponent(0.2)
    }
}


extension LocationTableHeaderView {

    static var instanceFromNib: LocationTableHeaderView {
        let nib = UINib(nibName: R.nib.locationTableHeaderView.name, bundle: R.nib.locationTableHeaderView.bundle)
        
        guard
            let view = nib.instantiate(withOwner: nil, options: nil).first as? LocationTableHeaderView
        else {
            fatalError()
        }
        
        return view
    }

    
    var title: String? {
        get { titleLabel.text }
        
        set {
            titleLabel.text = newValue
        }
    }
}
