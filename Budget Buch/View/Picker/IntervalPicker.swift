//
//  IntervalPicker.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 07.11.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class IntervalPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
 
    var data = [String]()
    var textfield = UITextField()
    var delegateNewEntry: NewEntryDelegate?
    
    init(textField: UITextField, data: [String], delegate: NewEntryDelegate) {
        super.init(frame: .zero)
        self.delegate = self
        self.data = data
        dataSource = self
        textfield = textField
        textfield.inputView = self
        delegateNewEntry = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textfield.text = data[row]
        delegateNewEntry?.updateConstraints()
    }
}
