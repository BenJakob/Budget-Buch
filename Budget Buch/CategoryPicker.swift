//
//  KategoriePicker.swift
//  Haushaltsbuch
//
//  Created by Benjamin Jakob on 02.08.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//

import UIKit

class CustomPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var data = [String]()
    var textfield = UITextField()
    
    init(textField: UITextField, data: [String]) {
        super.init(frame: .zero)
        self.delegate = self
        self.dataSource = self
        self.textfield = textField
        self.textfield.inputView = self
        self.data = data
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textfield.text =  data[row]
    }
}
