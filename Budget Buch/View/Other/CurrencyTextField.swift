//
//  CurrencyTextField.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 28.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class CurrencyTextField: UITextField, UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
}
