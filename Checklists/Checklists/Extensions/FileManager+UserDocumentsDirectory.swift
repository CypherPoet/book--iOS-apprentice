//
//  FileManager+UserDocumentsDirectory.swift
//  Checklists
//
//  Created by Brian Sipple on 6/9/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


extension FileManager {
    static var userDocumentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
