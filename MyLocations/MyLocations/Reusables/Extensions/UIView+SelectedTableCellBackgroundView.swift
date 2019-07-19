//
//  UIView+SelectedTableCellBackgroundView.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/18/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

extension UIView {
    
    static var selectedTableCellBackgroundView: UIView {
        let selectedView = UIView(frame: .zero)
        
        selectedView.backgroundColor = UIColor.systemGray3.withAlphaComponent(0.34)
        
        return selectedView
    }
}
