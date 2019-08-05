//
//  LoadingViewController.swift
//  StoreSearch
//
//  Created by Brian Sipple on 8/5/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    private lazy var spinner: UIActivityIndicatorView = makeSpinner()
    private let backgroundColor: UIColor
    
    
    init(backgroundColor: UIColor = .clear) {
        self.backgroundColor = backgroundColor
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    

extension LoadingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSpinner()
    }
}


private extension LoadingViewController {
    
    func setupSpinner() {
        view.addSubview(spinner)
        spinner.startAnimating()
        
        view.backgroundColor = backgroundColor
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    
    func makeSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)

        spinner.sizeToFit()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        return spinner
    }
}
