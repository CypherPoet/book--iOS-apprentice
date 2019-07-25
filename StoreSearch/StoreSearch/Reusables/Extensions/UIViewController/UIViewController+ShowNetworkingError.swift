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
            alertMessage: "🤔 Something went wrong",
            titled: """
                An error occurred while trying to access the iTunes Store.
                
                Please check your network connection and try again.
                """
        )
    }
}
