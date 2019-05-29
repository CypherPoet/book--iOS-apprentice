//
//  MainViewController.swift
//  BullsEye
//
//  Created by Brian Sipple on 5/25/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var slider: UISlider!
}


// MARK: - Computed Properties

extension MainViewController {
    
    var currentSliderValue: Int {
        return lroundf(slider.value)
    }
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
        display(alertMessage: "The value of the slider is \(currentSliderValue)", titled: "I'm Hit!")
    }
}
