//
//  Price.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/30/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


struct Price {
    let currencyCode: String
    let value: Double
}


extension Price {

    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency

        return formatter
    }()
    
    
    var formattedString: String? {
        Price.formatter.currencyCode = currencyCode

        return Price.formatter.string(from: value as NSNumber)
    }
}
