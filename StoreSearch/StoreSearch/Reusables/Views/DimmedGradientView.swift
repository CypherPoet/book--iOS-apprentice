//
//  DimmedGradientView.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/31/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import UIKit

final class DimmedGradientView: UIView {
    
    enum ColorStopComponents {
        enum DarkMode {
            static let first: [CGFloat] = [0.78, 0.78, 0.78, 0.6]
            static let second: [CGFloat] = [0.20, 0.20, 0.20, 0.88]
        }

        enum LightMode {
            static let first: [CGFloat] = [0.0, 0.0, 0.0, 0.2]
            static let second: [CGFloat] = [0.0, 0.0, 0.0, 0.8]
        }
    }
        
    enum ColorStopLocation {
        static let first: CGFloat = 0.0
        static let second: CGFloat = 1.0
    }
    
    private lazy var colorSpace = CGColorSpaceCreateDeviceRGB()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
}


// MARK: - Computeds
extension DimmedGradientView {
    var gradientCenter: CGPoint { .init(x: bounds.midX, y: bounds.midY) }
    var gradientRadius: CGFloat { max(gradientCenter.x, gradientCenter.y) }
    
    var gradientColorComponents: [CGFloat] {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return ColorStopComponents.DarkMode.first + ColorStopComponents.DarkMode.second
        case .light, .unspecified:
            return ColorStopComponents.LightMode.first + ColorStopComponents.LightMode.second
        @unknown default:
            return ColorStopComponents.LightMode.first + ColorStopComponents.LightMode.second
        }
    }
    
    var gradient: CGGradient? {
        CGGradient(
            colorSpace: colorSpace,
            colorComponents: gradientColorComponents,
            locations: [ColorStopLocation.first, ColorStopLocation.second],
            count: 2
        )
    }
}


// MARK: - Lifecycle
extension DimmedGradientView {
    
    override func draw(_ rect: CGRect) {
        guard let gradient = gradient else { return }
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.drawRadialGradient(
            gradient,
            startCenter: gradientCenter,
            startRadius: 0,
            endCenter: gradientCenter,
            endRadius: gradientRadius,
            options: .drawsAfterEndLocation
        )
    }
}



// MARK: - Private Helpers
private extension DimmedGradientView {

    func setupView() {
        backgroundColor = .clear
    }
}
