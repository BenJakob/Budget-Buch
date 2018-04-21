//
//  DatePicker.swift
//  Haushaltsbuch
//
//  Created by Benjamin Jakob on 22.10.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//

import UIKit

class DatePicker: UIDatePicker {
    
    var textfield = UITextField()
    
    init(textField: UITextField) {
        super.init(frame: .zero)
        self.textfield = textField
        textField.inputView = self

        self.datePickerMode = UIDatePickerMode.date
        self.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        textfield.text = DateFormatter.customFormatter.string(from: self.date)
    }
}
