//
//  UIViewController+ShowNetworkingError.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/24/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func showNetworkingError() {
        display(
            alertMessage: ErrorMessageStrings.NetworkingError.body.localized,
            titled: ErrorMessageStrings.NetworkingError.title.localized
        )
    }
}
