//
//  AboutViewController.swift
//  BullsEye
//
//  Created by Brian Sipple on 5/31/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit
import WebKit


class AboutViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadWebView()
    }
}


// MARK: - Private Helper Methods

private extension AboutViewController {
    
    func loadWebView() {
        guard let aboutPageURL = R.file.bullsEyeHtml() else {
            preconditionFailure("Failed to load web view for about page")
        }
        
        let requestToPage = URLRequest(url: aboutPageURL)
        
        webView.load(requestToPage)
    }
    
}
