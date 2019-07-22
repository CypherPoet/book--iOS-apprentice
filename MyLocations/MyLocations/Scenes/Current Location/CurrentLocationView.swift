//
//  CurrentLocationView.swift
//  MyLocations
//
//  Created by Brian Sipple on 6/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit


protocol CurrentLocationViewDelegate: class {
    func viewDidSelectFetchLocation(_ view: CurrentLocationView)
    func viewDidSelectStopLocationFetch(_ view: CurrentLocationView)
    func viewDidSelectTagLocation(_ view: CurrentLocationView)
}


class CurrentLocationView: UIView {
    @IBOutlet private var locationReadingHeaderLabel: UILabel!
    @IBOutlet private var latitudeLabel: UILabel!
    @IBOutlet private var longitudeLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var tagLocationButton: UIButton!
    @IBOutlet private var getLocationButton: UIButton!
    @IBOutlet private var coordinatesContainerView: UIStackView!
    @IBOutlet private var locationDataContainerView: UIStackView!
    @IBOutlet private var locationResultsContainerView: UIStackView!
    @IBOutlet private var locationSpinnerView: UIActivityIndicatorView!

    
    weak var delegate: CurrentLocationViewDelegate?
    
    var viewModel: ViewModel! {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { self.render(with: viewModel) }
        }
    }

    fileprivate enum AnimKey {
        static let slideInDataContainer = "Slide In Data Container"
        static let slideOutButtonOverlay = "Slide Out Button Overlay"
    }
    
    private lazy var startButtonOverlay: UIButton = makeStartButtonOverlay()
    
    
    var canTagLocation: Bool = false {
        didSet { animateVisibility(for: tagLocationButton, isShowing: canTagLocation) }
    }
    
    var canShowCoordinates: Bool = false {
        didSet { animateVisibility(for: coordinatesContainerView, isShowing: canShowCoordinates) }
    }
    
    var canShowAddress: Bool = false {
        didSet { animateVisibility(for: addressLabel, isShowing: canShowAddress) }
    }
    
    var shouldShowFetchingSpinner: Bool = false {
        didSet { DispatchQueue.main.async { self.locationSpinnerStateChanged() } }
    }
}


// MARK: Lifecycle

extension CurrentLocationView {
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        showStartButtonOverlay()
    }
}



// MARK: - Event Handling

extension CurrentLocationView {

    @IBAction func getLocationTapped(_ sender: UIButton) {
        if viewModel.isFetchingLocation {
            delegate?.viewDidSelectStopLocationFetch(self)
        } else {
            delegate?.viewDidSelectFetchLocation(self)
        }
    }
    
    
    @IBAction func tagLocationTapped(_ sender: UIButton) {
        delegate?.viewDidSelectTagLocation(self)
    }
    
    
    @objc func startButtonOverlayTapped(_ sender: UIButton) {
        hideStartButtonOverlay()
    }
}



// MARK: - Private Helpers

private extension CurrentLocationView {
    
    func render(with viewModel: ViewModel) {
        latitudeLabel.text = viewModel.latitudeText
        longitudeLabel.text = viewModel.longitudeText
        addressLabel.text = viewModel.decodedAddressText
        
        locationReadingHeaderLabel.text = viewModel.locationReadingHeaderText
        
        getLocationButton.setTitle(viewModel.locationFetchButtonText, for: .normal)
    }
    
    
    func animateVisibility(for view: UIView, isShowing: Bool) {
        DispatchQueue.main.async {
            view.isHidden = !isShowing

            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: [.curveEaseInOut],
                animations: {
                    view.alpha = isShowing ? 1 : 0.0
                }
            )
        }
    }
    
    
    func locationSpinnerStateChanged() {
        if shouldShowFetchingSpinner {
            animateVisibility(for: locationResultsContainerView, isShowing: false)
            locationSpinnerView.startAnimating()
        } else {
            animateVisibility(for: locationResultsContainerView, isShowing: true)
            locationSpinnerView.stopAnimating()
        }
    }
    
    
    func makeStartButtonOverlay() -> UIButton {
        let button = UIButton(type: .custom)
        
        button.setImage(R.image.tagLocation(), for: .normal)
        button.addTarget(self, action: #selector(startButtonOverlayTapped(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }
    
    
    func setupConstraints(for buttonOverlay: UIButton) {
        NSLayoutConstraint.activate([
            buttonOverlay.widthAnchor.constraint(equalTo: widthAnchor),
            buttonOverlay.topAnchor.constraint(equalTo: topAnchor),
            buttonOverlay.bottomAnchor.constraint(equalTo: getLocationButton.topAnchor),
        ])
    }
}


// MARK: Start Button Animation

private extension CurrentLocationView {
    
    func showStartButtonOverlay() {
        addSubview(startButtonOverlay)
        setupConstraints(for: startButtonOverlay)
        locationDataContainerView.isHidden = true
    }
    
    
    func hideStartButtonOverlay() {
        let dataContainerMover = makeDataContainerMoveInAnimation()
        let buttonOverlayMover = makeButtonOverlayMoveOutAnimation()
        
        startButtonOverlay.layer.add(buttonOverlayMover, forKey: AnimKey.slideOutButtonOverlay)
        
        dataContainerMover.delegate = self
        dataContainerMover.setValue(locationDataContainerView.layer, forKey: AnimKey.slideInDataContainer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + buttonOverlayMover.duration * 0.8) {
            self.locationDataContainerView.isHidden = false
            self.locationDataContainerView.layer.add(dataContainerMover, forKey: nil)
        }
    }

    
    func makeDataContainerMoveInAnimation() -> CAAnimationGroup {
        let animationGroup = CAAnimationGroup()

        animationGroup.duration = 0.6
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animationGroup.fillMode = .forwards
        
        let startTransform = CATransform3DMakeTranslation(bounds.size.width * 2, 0, 0)
        let endTransform = CATransform3DMakeTranslation(0, 0, 0)
        let moveAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        
        moveAnimation.fromValue = startTransform
        moveAnimation.toValue = endTransform
        
        let fadeInAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1

        // TODO: Maybe just do the fade in? The extra translation seems a bit jarring
        animationGroup.animations = [moveAnimation, fadeInAnimation]

        return animationGroup
    }
    
    
    // 🤔 This isn't actually rotating. I think I need a bit more intuition on how to use
    // `CATransform3DMakeRotation` and matrix-based calculations
    func makeButtonOverlayMoveOutAnimation() -> CABasicAnimation {
        let startingMove = CATransform3DMakeTranslation(0, 0, 0)
        let startingRotation = CATransform3DMakeRotation(0, 0, 0, 1)
        let startingTransform = CATransform3DConcat(startingRotation, startingMove)
        
        let endingMove = CATransform3DMakeTranslation(bounds.size.width * 2, 0, 0)
        let endingRotation = CATransform3DMakeRotation(-2 * .pi, 0, 0, 1)
        let endingTransform = CATransform3DConcat(endingRotation, endingMove)
        
        let moveAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        
        moveAnimation.fromValue = startingTransform
        moveAnimation.toValue = endingTransform
        moveAnimation.duration = 0.6
        moveAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.57, 0.03, 0.89, 0.40)
        moveAnimation.fillMode = .forwards
        moveAnimation.isRemovedOnCompletion = false
        
        return moveAnimation
    }
}


extension CurrentLocationView: CAAnimationDelegate {
    
    // Signal that location fetching was selected AFTER the initial animation finishes
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim.value(forKey: AnimKey.slideInDataContainer) != nil {
            startButtonOverlay.layer.removeAllAnimations()
            startButtonOverlay.removeFromSuperview()
            
            delegate?.viewDidSelectFetchLocation(self)
        }
    }
}
