//
//  UIViewController+DisplayPromptMessage.swift
//  MyLocations


import UIKit

extension UIViewController {
    func display(
        promptMessage: String,
        titled title: String = "",
        confirmButtonTitle: String = "OK",
        cancelButtonTitle: String = "Cancel",
        confirmationHandler: ((UIAlertAction) -> Void)? = nil,
        cancelationHandler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alertController = UIAlertController(
            title: title,
            message: promptMessage,
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(title: confirmButtonTitle, style: .default, handler: confirmationHandler)
        )
        
        alertController.addAction(
            UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelationHandler)
        )
        
        present(alertController, animated: true)
    }
}
