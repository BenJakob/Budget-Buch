//
//  Datepicker.swift
//  Haushaltsbuch
//
//  Created by Benjamin Jakob on 21.10.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//

import UIKit

class CustomDatePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var months = [String]()
    var years = [String]()
    
    var selectedMonth = ""
    var selectedYear = ""
    
    var textfield = UITextField()
    
    init(textField: UITextField, months: [String], years: [String]) {
        super.init(frame: .zero)
        self.delegate = self
        self.dataSource = self
        self.textfield = textField
        self.textfield.inputView = self
        self.months = months
        self.years = years
        selectedMonth = months[0]
        selectedYear = years[0]
        textField.text = selectedMonth + " " + selectedYear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            print(months.count)
            return months.count
        } else {
            print(years.count)
            return years.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return months[row]
        } else {
            return years[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedMonth = months[row]
        } else {
            selectedYear = years[row]
        }
        textfield.text = selectedMonth + " " + selectedYear
    }
}
