//
//  MainViewController.swift
//  BullsEye
//
//  Created by Brian Sipple on 5/25/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
}


// MARK: - Lifecycle

extension MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}


// MARK: - Event handling

extension MainViewController {
    
    @IBAction func hitMeButtonTapped(_ sender: UIButton) {
        display(alertMessage: "Well done!", titled: "I'm Hit!")
    }
}
