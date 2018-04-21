//
//  SaveButton.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 27.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class SaveButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 15
        layer.borderWidth = 2
        layer.borderColor = UIColor.appThemeColor.cgColor
        
        setTitle(SAVE, for: .normal)
        setTitleColor(.appThemeColor, for: .normal)
        setTitleColor(.white, for: .highlighted)
        
        titleLabel?.adjustsFontSizeToFitWidth = true
    }

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.appThemeColor : UIColor.white
        }
    }
}
