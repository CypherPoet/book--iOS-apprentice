//
//  LoadingViewController.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/5/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController, Storyboarded {
    private lazy var spinner: UIActivityIndicatorView = makeSpinner()
    
    var backgroundColor: UIColor = UIColor.systemFill.withAlphaComponent(0.4)
}
    

extension LoadingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSpinner()
        view.backgroundColor = backgroundColor
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.spinner.startAnimating()
        })
    }

}


private extension LoadingViewController {
    
    func setupSpinner() {
        view.addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        spinner.startAnimating()
    }
    
    
    func makeSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)

        spinner.sizeToFit()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        return spinner
    }
}
