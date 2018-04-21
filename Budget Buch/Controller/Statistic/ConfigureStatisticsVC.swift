//
//  ConfigureStatisticsVC.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 02.11.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class ConfigureStatisticsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var fileFormatLabel: UILabel!
    
    @IBOutlet weak var intervalPicker: UIPickerView!
    @IBOutlet weak var fileFormatPicker: UIPickerView!
    
    private var intervalData = [MONTHLY, YEARLY]
    private var fileFormatData = ["CSV", "PDF (coming soon)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(popViewController))
        navigationItem.leftBarButtonItem = leftBarButton
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = STATISTICS_TITLE
        intervalLabel.text = CONFIG_STAT_INTERVAL_LABEL
        fileFormatLabel.text = CONFIG_STAT_FILEFORMAT_LABEL
        
        intervalPicker.delegate = self
        intervalPicker.dataSource = self
        
        fileFormatPicker.delegate = self
        fileFormatPicker.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let interval = UserDefaults.standard.getInterval() {
            if interval == YEARLY {
                intervalPicker.selectRow(1, inComponent: 0, animated: false)
            }
        }
        
        if let fileFormat = UserDefaults.standard.getFileFormat() {
            if fileFormat == "PDF" {
                fileFormatPicker.selectRow(1, inComponent: 0, animated: false)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == intervalPicker {
            return intervalData.count
        } else {
            return fileFormatData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == intervalPicker {
            return intervalData[row]
        } else {
            return fileFormatData[row]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func popViewController() {
        let interval = intervalPicker.selectedRow(inComponent: 0)
        if interval == 0 {
            UserDefaults.standard.setInterval(value: MONTHLY)
        } else {
            UserDefaults.standard.setInterval(value: YEARLY)
        }
        
        let fileFormat = fileFormatPicker.selectedRow(inComponent: 0)
        if fileFormat == 0 {
            UserDefaults.standard.setFileFormat(value: "CSV")
        } else {
            UserDefaults.standard.setFileFormat(value: "PDF")
        }
        self.dismiss(animated: true, completion: nil)
    }

}
