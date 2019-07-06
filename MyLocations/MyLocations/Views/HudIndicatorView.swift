//
//  HudIndicatorView.swift
//  MyLocations
//
//  Created by Brian Sipple on 7/5/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

final class HudIndicatorView: UIView {
    private let underlyingView: UIView
    private let labelText: String?
    private let indicatorImage: UIImage?
    private var indicatorImageView: UIImageView?
    

    private lazy var blurEffect = UIBlurEffect(style: .systemThickMaterial)
    private lazy var vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .label)
    
    private lazy var blurView: UIVisualEffectView = makeBlurView()
    private lazy var vibrancyView: UIVisualEffectView = makeVibrancyView()
    
    private lazy var contentStackView: UIStackView = makeContentStackView()
    private lazy var indicatorLabel: UILabel = makeIndicatorLabel()
    
    
    var containerWidth: CGFloat = 148
    var containerHeight: CGFloat = 148

    
    init(
        covering underlyingView: UIView,
        labeled labelText: String? = nil,
        withImage indicatorImage: UIImage? = nil
    ) {
        self.underlyingView = underlyingView
        self.labelText = labelText
        self.indicatorImage = indicatorImage
        
        super.init(frame: underlyingView.bounds)
        
        setupView()
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Static Methods

extension HudIndicatorView {

    static func temporaryOverlay(
        covering underlyingView: UIView,
        labeled label: String,
        withImage indicatorImage: UIImage? = nil,
        animated: Bool = true,
        removeAfter duration: TimeInterval,
        allowInteraction: Bool = false,
        onRemove removalCompletionHandler: @escaping (() -> Void)
    ) -> HudIndicatorView {
        let hudIndicator = HudIndicatorView(covering: underlyingView, labeled: label, withImage: indicatorImage)
        
        underlyingView.isUserInteractionEnabled = allowInteraction
        underlyingView.addSubview(hudIndicator)
        hudIndicator.show(animated: animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            underlyingView.isUserInteractionEnabled = true
            hudIndicator.removeFromSuperview()
            
            removalCompletionHandler()
        }
        
        return hudIndicator
    }
    
}


// MARK: - Core Methods

extension HudIndicatorView {
    
    func show(animated: Bool = true) {
        if animated {
            alpha = 0
            transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//            transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0.5,
                options: [.curveEaseOut],
                animations: {
                    self.alpha = 1
                    self.transform = .identity
                },
                completion: { _ in
                    
                }
            )
        }
    }
    
    
    func hide() {
        removeFromSuperview()
    }
}



// MARK: - Private Helpers

private extension HudIndicatorView {
    
    func setupView() {
        isOpaque = false
        backgroundColor = .clear
        
        blurView.contentView.addSubview(vibrancyView)
        insertSubview(blurView, at: 0)
    }
    

    func setupLayout() {
        if let indicatorImageView = indicatorImageView {
            NSLayoutConstraint.activate([
                indicatorImageView.widthAnchor.constraint(equalToConstant: containerWidth / 2),
                indicatorImageView.heightAnchor.constraint(equalToConstant: containerHeight / 2),
            ])
        }
        
        NSLayoutConstraint.activate([
            contentStackView.centerXAnchor.constraint(equalTo: vibrancyView.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: vibrancyView.centerYAnchor),
        ])
        
        setupContstraints(for: vibrancyView, in: blurView)
        
        NSLayoutConstraint.activate([
            blurView.centerXAnchor.constraint(equalTo: centerXAnchor),
            blurView.centerYAnchor.constraint(equalTo: centerYAnchor),
            blurView.widthAnchor.constraint(equalToConstant: containerWidth),
            blurView.heightAnchor.constraint(equalToConstant: containerHeight),
        ])
    }
    
    
    func makeBlurView() -> UIVisualEffectView {
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView.layer.cornerRadius = 14
        blurView.layer.cornerCurve = .continuous
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurView
    }
    
    
    func makeVibrancyView() -> UIVisualEffectView {
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        
        vibrancyView.contentView.addSubview(contentStackView)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false

        return vibrancyView
    }
    
    
    func makeContentStackView() -> UIStackView {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.distribution = .fill
        
        if let indicatorImage = indicatorImage {
            indicatorImageView = UIImageView(image: indicatorImage)
            stackView.addArrangedSubview(indicatorImageView!)
            indicatorImageView!.translatesAutoresizingMaskIntoConstraints = false
        }
        
        stackView.addArrangedSubview(indicatorLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
    
    
    func makeIndicatorLabel() -> UILabel {
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .headline, compatibleWith: self.traitCollection)
        label.text = labelText
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    
    func setupContstraints(for vibrancyView: UIView, in blurView: UIView) {
        NSLayoutConstraint.activate([
            vibrancyView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor),
            vibrancyView.topAnchor.constraint(equalTo: blurView.topAnchor),
            vibrancyView.trailingAnchor.constraint(equalTo: blurView.trailingAnchor),
            vibrancyView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor),
        ])
    }
}
