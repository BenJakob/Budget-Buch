//
//  AddController.swift
//  Haushaltsbuch
//
//  Created by Benjamin Jakob on 02.08.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//

import UIKit
import CoreData

class AddController: UITableViewController {
    
    private let cellId = "cellId"
    private let saveCellId = "saveCellId"
    
    private var headerData = [" "]
    private var dataSection = ["Datum", "Wiederholung", "Betrag", "Kategorie"]
    private var repeatingModusData = ["niemals", "wöchentlich", "monatlich", "jährlich"]
    private var incomeCategoryData = ["", "Trinkgeld", "Sonstige Einnahme"]
    private var expenseCategoryData = ["", "Gesundheit" , "Geschenke", "Kleidung", "Kneipe", "Lebensmittel", "Restaurant", "Transport", "Wohnung", "Sonstige Ausgabe"]
    
    private var amount = UITextField()
    private var category = UITextField()
    private var date = UITextField()
    private var repeatingModus = UITextField()
    private var isIncome = Bool()
    private weak var mainController: ArchiveController?
    
    init(style: UITableViewStyle, isIncome: Bool, controller: ArchiveController) {
        super.init(style: style)
        self.isIncome = isIncome
        self.mainController = controller
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.title = "Neuer Eintrag"
        tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        tableView.register(StandardCell.self, forCellReuseIdentifier: cellId)
        tableView.register(SaveButtonCell.self, forHeaderFooterViewReuseIdentifier: saveCellId)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return headerData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSection.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StandardCell
            cell.nameLabel.text = dataSection[indexPath.row]
            cell.selectionStyle = .none
            cell.textField.clearButtonMode = .whileEditing
            cell.textField.tintColor = .clear
            cell.textField.clearButtonMode = .never
            cell.textField.inputView = DatePicker(textField: cell.textField)
            date = cell.textField
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StandardCell
            cell.nameLabel.text = dataSection[indexPath.row]
            cell.textField.placeholder = "..."
            cell.textField.text = repeatingModusData[0]
            cell.selectionStyle = .none
            _ = CustomPicker(textField: cell.textField, data: repeatingModusData)
            repeatingModus = cell.textField
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StandardCell
            cell.nameLabel.text = dataSection[indexPath.row]
            cell.textField.placeholder = NumberFormatter.currencyFormatter.string(from: 0.0)
            cell.textField.keyboardType = .decimalPad
            cell.selectionStyle = .none
            amount = cell.textField
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StandardCell
            cell.nameLabel.text = dataSection[indexPath.row]
            cell.textField.placeholder = "..."
            cell.selectionStyle = .none
            if isIncome {
                _ = CustomPicker(textField: cell.textField, data: incomeCategoryData)
            } else {
                _ = CustomPicker(textField: cell.textField, data: expenseCategoryData)
            }
            category = cell.textField
            return cell
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StandardCell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerData[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: saveCellId) as! SaveButtonCell
        cell.myTableViewController = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc func saveInput(sender: UIButton) {
        if repeatingModus.text!.isEmpty || category.text!.isEmpty || amount.text!.isEmpty {
            showWarning()
        } else {
            
            guard let date = date.text else { return }
            guard let category = category.text else { return }
            guard let periode = repeatingModus.text else { return }
            guard let amount = amount.text else { return }
            
            if periode == "Niemals" {                
                if isIncome {
                    DatabaseController.insertEntry(forEntityName: "IncomeEntry", as: .incomeEntry, category: category, date: date, amount: amount, periode: periode)
                } else {
                    DatabaseController.insertEntry(forEntityName: "ExpenseEntry", as: .expenseEntry, category: category, date: date, amount: amount, periode: periode)
                }
            } else {
                if isIncome {
                    DatabaseController.insertEntry(forEntityName: "RepeatingIncome", as: .repeatingIncome, category: category, date: date, amount: amount, periode: periode)
                } else {
                    DatabaseController.insertEntry(forEntityName: "RepeatingExpense", as: .repeatingExpense, category: category, date: date, amount: amount, periode: periode)
                }
            }
            
            DatabaseController.saveContext()
            _ = self.navigationController?.popViewController(animated: true)
//            mainController?.showSuccess()
        }
    }
    
    func showWarning() {
        let alertController = UIAlertController(title: "Fehler", message: "Bitte Betrag und Kategorie angeben!", preferredStyle: UIAlertControllerStyle.alert)
        alertController.view.tintColor = .appThemeColor
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}


