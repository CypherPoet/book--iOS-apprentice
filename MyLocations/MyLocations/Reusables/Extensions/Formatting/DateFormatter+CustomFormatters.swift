//
//  DateFormatter+CustomFormatters.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/3/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static var locationDetailsDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }
}
