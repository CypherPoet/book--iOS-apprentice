//
//  UIImage+ResizedWithBounds.swift
//  iOSReusables
//
//  Created by Brian Sipple on 7/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//


import UIKit

extension UIImage {
    
    private func newImage(with newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        return newImage
    }
    

    func resized(withBounds bounds: CGSize) -> UIImage? {
        let horizontalMultiple = bounds.width / size.height
        let verticalMultiple = bounds.height / size.width
        
        let minMultiple = min(horizontalMultiple, verticalMultiple)
        let newSize = CGSize(width: size.width * minMultiple, height: size.height * minMultiple)

        return newImage(with: newSize)
    }
}
