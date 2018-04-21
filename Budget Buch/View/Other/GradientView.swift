//
//  GradientView.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 26.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class GradientView: UIView {

    @IBInspectable var topColor: UIColor = .blue {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var buttonColor: UIColor = .green {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, buttonColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
