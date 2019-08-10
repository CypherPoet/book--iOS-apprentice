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
        comment: String? = nil,
        bundle: Bundle = .main,
        tableName: String = "Localizable"
    ) -> String {
        let key = key ?? self
        let comment = comment ?? "Localization for \"\(key)\""
        let defaultValue = "🌎🌎\(self)🌎🌎"
        
        return NSLocalizedString(
            key,
            tableName: tableName,
            bundle: bundle,
            value: defaultValue,
            comment: comment
        )
    }
    
    
    func localized(
        with variable: CVarArg,
        key: String? = nil,
        comment: String? = nil,
        bundle: Bundle = .main,
        tableName: String = "Localizable"
    ) -> String {
        let formatString = self.localized(key: key, comment: comment, bundle: bundle, tableName: tableName)

        return String(format: formatString, variable)
    }
}
