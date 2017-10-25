//
//  ExportController.swift
//  Haushaltsbuch
//
//  Created by Benjamin Jakob on 02.08.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//

import UIKit
import CoreData

class ExportController: UITableViewController {
    
//    var headerData = [" "]
    let exportCellId = "exportCellId"
    let removeAdsCellId = "removeAdsCellId"
    let categories = ["Trinkgeld", "Sonstige Einnahme", "Gesundheit" , "Geschenke", "Kleidung", "Kneipe", "Lebensmittel", "Restaurant", "Transport", "Wohnung", "Sonstige Ausgabe"]
    var categorySums = [Double]()
    var entries = [Entry]()
    var fileURL: URL?
    var datePicker: CustomDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.register(ExportButtonCell.self, forHeaderFooterViewReuseIdentifier: exportCellId)
        tableView.register(RemoveAdsButtonCell.self, forHeaderFooterViewReuseIdentifier: removeAdsCellId)
        tableView.register(StandardCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(AddCell.self, forCellReuseIdentifier: "addCell")
        for _ in categories {
            categorySums.append(0.0)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: exportCellId) as! ExportButtonCell
            cell.myTableViewController = self
            return cell
        } else {
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: removeAdsCellId) as! RemoveAdsButtonCell
            cell.myTableViewController = self
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        }
        return 250
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! StandardCell
            cell.selectionStyle = .none
            cell.nameLabel.text = "Monat"
            cell.textField.clearButtonMode = .never
            cell.textField.tintColor = .clear
            datePicker = CustomDatePicker(textField: cell.textField, months: getMonths(), years: getYears())
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! AddCell
            cell.adView.rootViewController = self
            return cell
        }
    }
    
    private func loadEntries() {
        do {
            entries = [Entry]()
            let entriesFetchRequest: NSFetchRequest<Entry>?
            entriesFetchRequest = Entry.fetchRequest()
            let fetchedEntries = try DatabaseController.getContext().fetch(entriesFetchRequest!)
            
            for entry in fetchedEntries {
                if DateFormatter.monthFormatter.string(from: entry.date! as Date) == datePicker?.selectedMonth && DateFormatter.yearFormatter.string(from: entry.date! as Date) == datePicker?.selectedYear {
                    entries.append(entry)
                }
            }
        } catch let error as NSError {
            print("Error loading Entries: \(error) ")
        }
    }
    
    @objc func exportData(sender: UIButton) {
        let fileName = "haushaltsbuch"
        for (index, _) in categorySums.enumerated() {
            categorySums[index] = 0.0
        }
        loadEntries()
        let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("csv")
            
        if fileURL != nil  {
            do {
                for entry in entries {
                    for (index, category) in categories.enumerated() {
                        if entry.category == category {
                            entry is IncomeEntry ? ( categorySums[index] += entry.amount ) : ( categorySums[index] -= entry.amount )
                        }
                    }
                }
                
                var exportData = "Kategorie;Betrag\n"
                for (index, sum) in categorySums.enumerated() {
                    exportData += categories[index] + ";"
                    exportData += NumberFormatter.currencyFormatter.string(from: sum as NSNumber)! + "\n"
                }
                try exportData.write(to: fileURL!, atomically: true, encoding: .utf8)
                
            } catch let error as NSError {
                print("Error: \(error)")
            }
        }
        
        let activityViewController = UIActivityViewController(activityItems: [fileURL!], applicationActivities: nil)
        activityViewController.view.tintColor = .appThemeColor
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.completionWithItemsHandler = {
            (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed == true {
                self.completionHandler()
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func completionHandler() {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: fileURL!)
        }
        catch let error as NSError {
            print("Error: \(error)")
        }
    }
    
//    private func showSuccess() {
//        let alertController = UIAlertController(title: "Bussi", message: "Daten exportiert. 😘😍😘 Als Belohnung!", preferredStyle: UIAlertControllerStyle.alert)
//        alertController.view.tintColor = .appThemeColor
//        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    private func getMonths() -> [String] {
        var months = [String]()
        for index in 0...11 {
            let date = Calendar.current.date(byAdding: .month, value: -index, to: Date())
            months.append(DateFormatter.monthFormatter.string(from: date!))
        }
        return months
    }
    
    private func getYears() -> [String] {
        var years = [String]()
        for index in 0...29 {
            let date = Calendar.current.date(byAdding: .year, value: -index, to: Date())
            years.append(DateFormatter.yearFormatter.string(from: date!))
        }
        return years
    }
}

