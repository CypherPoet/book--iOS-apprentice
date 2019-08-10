//
//  String+Localization.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/8/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


extension String {
    
    func localized(
        key: String? = nil,
        bundle: Bundle = .main,
        tableName: String = "Localizable"
    ) -> String {
        let key = key ?? self
        let defaultValue = "🌎🌎\(self)🌎🌎"
        
        // 📝 `comment` might as well be empty here, because this function won't be making
        // use of `genstrings` -- which would use the `comment` as the generated comment
        // in a .strings file.
        // (See: https://stackoverflow.com/questions/44125665/has-anyone-got-string-type-enums-to-work-with-genstrings)
        return NSLocalizedString(
            key,
            tableName: tableName,
            bundle: bundle,
            value: defaultValue,
            comment: ""
        )
    }
    
    
    func localized(
        with variable: CVarArg,
        key: String? = nil,
        bundle: Bundle = .main,
        tableName: String = "Localizable"
    ) -> String {
        let formatString = self.localized(key: key, bundle: bundle, tableName: tableName)

        return String(format: formatString, variable)
    }
}
