//
//  FileManager+UserDocumentsDirectory.swift
//  iOSReusables
//
//  Created by Brian Sipple on 5/6/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

extension FileManager {
    static var userDocumentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
