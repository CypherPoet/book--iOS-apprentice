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
    
    @IBOutlet private var roundedButtons: [UIButton]!
    
    var currentTargetValue = 0 {
        didSet {
            DispatchQueue.main.async {
                self.targetValueLabel.text = "\(self.currentTargetValue)"
            }
        }
    }
    
    var currentScore = 0 {
        didSet {
            DispatchQueue.main.async {
                self.currentScoreLabel.text = "\(self.currentScore)"
            }
        }
    }
    
    var currentRound = 0 {
        didSet {
            DispatchQueue.main.async {
                self.roundChanged()
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
    
    var distanceFromTarget: Int {
        return abs(currentSliderValue - currentTargetValue)
    }
    
    var pointsForHit: Int {
        return distanceFromTarget == 0 ? 200 : ((100 - distanceFromTarget) / 5)
    }
    
    
    var titleForHit: String {
        switch distanceFromTarget {
        case 0:
            return "Bullseye! 🎯"
        case 1...10:
            return "Close!"
        case 11...22:
            return "Getting There"
        default:
            return "Far Off"
        }
    }
    

    var alertMessageForHit: String {
        if distanceFromTarget == 0 {
            return """
                You hit the target perfectly!

                That's going to be worth \(pointsForHit) points.
                """
        } else {
            return """
                The value of the slider is \(currentSliderValue).

                You were off by \(distanceFromTarget).

                That's going to be worth \(pointsForHit) points.
                """
        }
    }
    
}


// MARK: - Lifecycle

extension MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleUI()
        startNewGame()
    }
    
    
}


// MARK: - Event handling

extension MainViewController {
    
    @IBAction func hitMeButtonTapped(_ sender: UIButton) {
        display(
            alertMessage: alertMessageForHit,
            titled: titleForHit,
            confirmationHandler: { [weak self] _ in
                guard let self = self else { return }
                
                self.currentScore += self.pointsForHit
                self.currentRound += 1
            }
        )
    }
    
    
    @IBAction func startOverButtonTapped(_ sender: UIButton) {
        startNewGame()
    }

}


// MARK: - Private Helper Methods

private extension MainViewController {
    
    func startNewGame() {
        currentScore = 0
        currentRound = 1
    }
    
    
    func roundChanged() {
        currentTargetValue = newTargetValue
        currentRoundLabel.text = "\(currentRound)"
        slider.setValue(startingSliderValue, animated: true)
    }
    

    func styleUI() {
        styleSlider()
        styleButtons()
    }
    
    
    func styleSlider() {
        slider.setThumbImage(R.image.sliderBullseye(), for: .normal)
        slider.setThumbImage(R.image.sliderBullseyePressed(), for: .highlighted)
        
        let trackInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        let minTrackImage = R.image.sliderMinTrack()!.resizableImage(withCapInsets: trackInsets)
        let maxTrackImage = R.image.sliderMaxTrack()!.resizableImage(withCapInsets: trackInsets)
        
        slider.setMinimumTrackImage(minTrackImage, for: .normal)
        slider.setMaximumTrackImage(maxTrackImage, for: .normal)
    }
    
    
    
    func styleButtons() {
        for button in roundedButtons {
            button.layer.cornerRadius = button.frame.width / 5
        }
    }
}
