//
//  UIViewController+DisplayAlertMessage.swift
//  Checklists
//
//  Created by Brian Sipple on 6/2/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

extension UIViewController {
    func display(
        alertMessage: String,
        titled title: String = "",
        confirmButtonTitle: String = "OK",
        confirmationHandler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alertController = UIAlertController(
            title: title,
            message: alertMessage,
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(title: confirmButtonTitle, style: .default, handler: confirmationHandler)
        )
        
        present(alertController, animated: true)
    }
}
