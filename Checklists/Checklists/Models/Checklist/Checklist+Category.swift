//
//  Checklist+Category.swift
//  Checklists
//
//  Created by Brian Sipple on 6/14/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


extension Checklist {
    enum Category: String, CaseIterable {
        case misc
        case appointments
        case drawing
        case experiments
        case folder
        case inbox
        case photos
        case supplies
        case trips
        
        
        var iconImage: UIImage? {
            switch self {
            case .misc:
                return R.image.noIcon()
            case .appointments:
                return R.image.appointments()
            case .drawing:
                return R.image.drawing()
            case .experiments:
                return R.image.experiments()
            case .folder:
                return R.image.folder()
            case .inbox:
                return R.image.inbox()
            case .photos:
                return R.image.photos()
            case .supplies:
                return R.image.supplies()
            case .trips:
                return R.image.trips()
            }
        }
        

        var title: String {
            switch self {
            case .misc:
                return "Miscellaneous"
            case .appointments:
                return "Appointments"
            case .experiments:
                return "Experiments"
            case .drawing:
                return "Drawing"
            case .folder:
                return "Folder"
            case .inbox:
                return "Inbox"
            case .photos:
                return "Photos"
            case .supplies:
                return "Supplies"
            case .trips:
                return "Trips"
            }
        }
    }
}


extension Checklist.Category: Codable {}
