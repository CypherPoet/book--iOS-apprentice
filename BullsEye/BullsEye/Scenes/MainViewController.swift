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
    @IBOutlet private weak var targetValueLabel: UILabel!
    @IBOutlet private weak var currentRoundLabel: UILabel!
    @IBOutlet private weak var currentScoreLabel: UILabel!
    
    
    var currentTargetValue = 0 {
        didSet {
            targetValueLabel.text = "\(currentTargetValue)"
        }
    }
    
    var currentScore = 0 {
        didSet {
            currentScoreLabel.text = "\(currentScore)"
        }
    }
    
    var currentRound = 0 {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.roundChanged()
            }
        }
    }
}


// MARK: - Computed Properties

extension MainViewController {
    
    var currentSliderValue: Int {
        return lroundf(slider.value)
    }
    
    var newTargetValue: Int {
        return Int.random(in: 1...100)
    }
    
    var startingSliderValue: Float {
        return currentTargetValue > 50 ? 0.0 : 100.0
    }
}


// MARK: - Lifecycle

extension MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentScore = 0
        currentRound = 1
    }
    
    
}


// MARK: - Event handling

extension MainViewController {
    
    @IBAction func hitMeButtonTapped(_ sender: UIButton) {
        display(
            alertMessage: "The value of the slider is \(currentSliderValue)",
            titled: "I'm Hit!",
            confirmationHandler: { [weak self] _ in
                self?.currentRound += 1
            }
        )
    }
}


// MARK: - Private Helper Methods

private extension MainViewController {
    
    func roundChanged() {
        currentTargetValue = newTargetValue
        currentRoundLabel.text = "\(currentRound)"
        slider.setValue(startingSliderValue, animated: true)
    }
    
}
