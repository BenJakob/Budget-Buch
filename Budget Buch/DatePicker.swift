//
//  DatePicker.swift
//  Haushaltsbuch
//
//  Created by Benjamin Jakob on 22.10.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//

import UIKit

class DatePicker: UIDatePicker {

    let dateComponents: DateComponents = {
        var components = DateComponents()
        components.year = 0
        return components
    }()
    
    var textfield = UITextField()
    
    init(textField: UITextField) {
        super.init(frame: .zero)
        self.textfield = textField
        self.textfield.text = DateFormatter.customFormatter.string(from: self.date)
        
        let maxDate = Calendar.current.date(byAdding: dateComponents, to: Date())
        self.maximumDate = maxDate
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
