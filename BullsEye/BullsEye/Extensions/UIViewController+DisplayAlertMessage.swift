//
//  UIViewController+DisplayAlertMessage.swift
//  BullsEye
//
//  Created by Brian Sipple on 5/27/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
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
