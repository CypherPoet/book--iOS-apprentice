//
//  UserDefaults.swift
//  Checklists
//
//  Created by Brian Sipple on 6/11/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


extension UserDefaults {
    enum Keys {
        static let currentChecklistIndexPathRow = DefaultsKey<Int>("Current Checklist Index Path Row")
        static let currentChecklistIndexPathSection = DefaultsKey<Int>("Current Checklist Index Path Section")
        static let isFirstRunOfApp = DefaultsKey<Bool>("Is First Run of Application")
    }
    
    
    struct DefaultsKey<T> {
        let keyName: String
        
        init(_ keyName: String) {
            self.keyName = keyName
        }
        
        
        func get() -> T? {
            return UserDefaults.standard.value(forKey: keyName) as? T
        }
        
        func get(defaultValue: T) -> T {
            return (UserDefaults.standard.value(forKey: keyName) as? T) ?? defaultValue
        }
        
        func set(_ value: T) {
            UserDefaults.standard.set(value, forKey: keyName)
        }
        
        
        func removeValue() {
            UserDefaults.standard.removeObject(forKey: keyName)
        }
    }
}
