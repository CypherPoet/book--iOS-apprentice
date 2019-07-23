//
//  UIView+SelectedTableCellBackgroundView.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/23/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


extension UIView {
    
    static var selectedTableCellBackground: UIView {
        let view = UIView(frame: .zero)
        
        view.backgroundColor = UIColor.Theme.background.withAlphaComponent(0.33)
        
        return view
    }
}
