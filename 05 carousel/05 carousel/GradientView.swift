//
//  GradientView.swift
//  05 carousel
//
//  Created by 1 on 07/04/2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit

class GradientView: UIView {

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        let colors = [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.red.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations: [CGFloat] = [0.0, 0.5, 1.0]
        
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations) {
            let startPoint = CGPoint.zero
            let endPoint = CGPoint(x: 0, y: bounds.height)
            context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        }
    }

}
