//
//  SplitViewDetailsContainerViewController.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/14/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit
import MessageUI


protocol SplitViewDetailsContainerViewControllerDelegate: class {
    func viewControllerDidTapAppMenuButton(_ controller: SplitViewDetailsContainerViewController)
}


class SplitViewDetailsContainerViewController: UIViewController {
    weak var delegate: SplitViewDetailsContainerViewControllerDelegate?
}


// MARK: - Event Handling
extension SplitViewDetailsContainerViewController {
    
    @IBAction func appMenuButtonTapped(_ sender: UIBarButtonItem) {
        let appMenuVC = AppMenuViewController.instantiateFromStoryboard(
            named: R.storyboard.appMenu.name
        )
        
        appMenuVC.delegate = self
        
        present(appMenuVC, animated: true)
    }
}


extension SplitViewDetailsContainerViewController: AppMenuViewControllerDelegate {
    
    func viewControllerDidSelectSendMail(_ controller: AppMenuViewController) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Mail services are not available")
            return
        }
        
        let mailVC = MFMailComposeViewController()
        
        // TODO: Localize these strings
        mailVC.setSubject("Support Request")
        mailVC.setToRecipients(["cypherpoet@gmail.com"])
        
        
        controller.present(mailVC, animated: true)
    }
}



extension SplitViewDetailsContainerViewController: Storyboarded {}
