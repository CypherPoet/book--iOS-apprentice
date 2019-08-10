//
//  UIViewController+ShowNetworkingError.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/24/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


fileprivate let errorMessage = """
    An error occurred while trying to access the iTunes Store.
        
    Please check your network connection and try again.
    """


extension UIViewController {
    
    func showNetworkingError() {
        display(
            alertMessage: "🤔 Something went wrong".localized(
                comment: "Title for a network error displayed in an alert dialog"
            ),
            titled: errorMessage.localized(
                key: "Networking Error Message",
                comment: "Message for a network error displayed in an alert dialog"
            )
        )
    }
}
