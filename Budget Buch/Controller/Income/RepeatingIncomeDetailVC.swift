//
//  RepeatingIncomeDetailVC.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 05.11.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class RepeatingIncomeDetailVC: UIViewController, UITextFieldDelegate, RepeatingIncomeDetailDelegate {
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var intervalTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var saveButton: SaveButton!
    @IBOutlet weak var buttonYPosition: NSLayoutConstraint!
    
    let intervalData = [WEEKLY, MONTHLY, YEARLY]
    var incomeDelegate: RepeatingIncomeDelegate?
    var income: RepeatingIncome?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NEW_FIX_INCOMES_TITLE
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        configureTextFields()
        
        if UIDevice.current.modelName == "iPhone SE" {
            let alternativeSaveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(safe))
            navigationItem.rightBarButtonItem = alternativeSaveButton
            saveButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let categories = DataService.shared.getIncomesCategories()
        var categoryNames = [String]()
        categoryNames.append("")
        for category in categories {
            categoryNames.append(category.name!)
        }
        _ = CustomPicker(textField: categoryTextField, data: categoryNames)
    }
    
    private func configureTextFields() {
        startDateLabel.text = START_DATE
        endDateLabel.text = END_DATE
        intervalLabel.text = INTERVAL
        categoryLabel.text = CATEGORY
        amountLabel.text = AMOUNT
        
        startDateTextField.text = DateFormatter.customFormatter.string(from: Date())
        endDateTextField.placeholder = OPTIONAL
        intervalTextField.text = MONTHLY
        categoryTextField.placeholder = SELECTCATEGORY
        amountTextField.placeholder = NumberFormatter.currencyFormatter.string(from: 0.0 as NSNumber)
        
        startDateTextField.tintColor = .clear
        endDateTextField.tintColor = .clear
        intervalTextField.tintColor = .clear
        categoryTextField.tintColor = .clear
        
        endDateTextField.clearButtonMode = .whileEditing
        amountTextField.clearButtonMode = .whileEditing
        amountTextField.keyboardType = .decimalPad
        
        _ = DatePicker(textField: startDateTextField)
        _ = DatePicker(textField: endDateTextField)
        _ = CustomPicker(textField: intervalTextField, data: intervalData)
    }
    
    func configureView(repeatingIncome: RepeatingIncome?) {
        if let income = repeatingIncome {
            self.income = income
            startDateTextField.text = DateFormatter.customFormatter.string(from: income.date! as Date)
            categoryTextField.text = income.category!.name
            intervalTextField.text = income.interval
            amountTextField.text = NumberFormatter.decimalFormatter.string(from: income.amount as NSNumber)
            navigationItem.title = income.category!.name!
            guard let endDate = income.endDate else { return }
            endDateTextField.text = DateFormatter.customFormatter.string(from: endDate as Date)
        } else {
            self.income = nil
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: SaveButton) {
        safe()
    }
    
    @objc private func safe(){
        guard let startDate = startDateTextField.text else { return }
        guard let category = categoryTextField.text else { return }
        guard let interval = intervalTextField.text else { return }
        guard let amount = amountTextField.text else { return }
        guard let formattedAmount = NumberFormatter.decimalFormatter.number(from: amount) else { return }
        
        if startDate.isEmpty || category.isEmpty || interval.isEmpty || amount.isEmpty {
            showWarning(title: ERROR_TITLE, message: EMPTY_FIELD_MESSAGE)
        } else {
            
            let categories = DataService.shared.getCategory(byName: category)
            if categories.count > 0 {
                if let editIncome = income {
                    editIncome.date = DateFormatter.customFormatter.date(from: startDate)
                    editIncome.category = categories[0]
                    editIncome.interval = interval
                    editIncome.amount = Double(truncating: formattedAmount)
                    if let endDate = endDateTextField.text {
                        editIncome.endDate = DateFormatter.customFormatter.date(from: endDate)
                    }
                    incomeDelegate?.updateTable()
                    navigationController?.popViewController(animated: true)
                } else {
                    let incomes = DataService.shared.getRepeatingIncome()
                    let filteredIncomes = incomes.filter({ $0.category?.name == category })
                    if filteredIncomes.count > 0 {
                        showWarning(title: ERROR_TITLE, message: INCOME_EXISTS_MESSAGE)
                    } else {
                        if let date = DateFormatter.customFormatter.date(from: startDate) {
                            let currentDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
                            if date < currentDate! {
                                let alertController = UIAlertController(title: AUTOFILL_TITLE, message: AUTOFILL_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
                                alertController.view.tintColor = .appThemeColor
                                alertController.addAction(UIAlertAction(title: AUTOFILL_YES, style: .default, handler: { (action) in
                                    if let newIncome = DatabaseController.insertRepeatingIncome(category: categories[0], startDate: startDate, endDate: self.endDateTextField.text, amount: amount, interval: interval) {
                                        DatabaseController.insertMissingRepeatingIncomes([newIncome], beginAt: date)
                                    self.insertInParentViewController(newIncome: newIncome)
                                    } else {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }))
                                alertController.addAction(UIAlertAction(title: AUTOFILL_NO, style: .default, handler: { (action) in
                                    if let newIncome = DatabaseController.insertRepeatingIncome(category: categories[0], startDate: startDate, endDate: self.endDateTextField.text, amount: amount, interval: interval) {
                                        DatabaseController.insertMissingRepeatingIncomes([newIncome], beginAt: Date())
                                        self.insertInParentViewController(newIncome: newIncome)
                                    } else {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }))
                                self.present(alertController, animated: true, completion: nil)
                            } else {
                                if let newIncome = DatabaseController.insertRepeatingIncome(category: categories[0], startDate: startDate, endDate: self.endDateTextField.text, amount: amount, interval: interval) {
                                    DatabaseController.insertMissingRepeatingIncomes([newIncome], beginAt: Date())
                                    self.insertInParentViewController(newIncome: newIncome)
                                }
                            }
                        }
                    }
                }
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func insertInParentViewController(newIncome: RepeatingIncome) {
        navigationController?.popViewController(animated: true)
        guard let delegate = self.incomeDelegate else { return }
        delegate.insertIncome(newIncome)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        if let income = income {
            var incomes = DataService.shared.getIncome()
            incomes = incomes.filter({ $0.isRepeating && $0.category == income.category })
            if incomes.count > 0 {
                deleteRepeatingEntryAlert()
            } else {
                navigationController?.popViewController(animated: true)
                incomeDelegate?.deleteIncome()
            }
        }
    }
    
    func deleteRepeatingEntryAlert() {
        let alert = UIAlertController(title: DELETE_TITLE, message: DELETE_REPEATING_ENTRY_MESSAGE, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.view.tintColor = .appThemeColor
        let confirm = UIAlertAction(title: DELETE_FIX_ENTRY, style: .destructive, handler: {(action) in
            self.navigationController?.popViewController(animated: true)
            self.incomeDelegate?.deleteIncome()
        })
        let confirmAll = UIAlertAction(title: DELETE_ALL_ENTRIES, style: .destructive, handler: deleteIncomes)
        let chancel = UIAlertAction(title: CANCEL, style: .cancel, handler: nil)
        
        alert.addAction(confirmAll)
        alert.addAction(confirm)
        alert.addAction(chancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteIncomes(action: UIAlertAction) {
        if let income = income {
            var incomes = DataService.shared.getIncome()
            incomes = incomes.filter({ $0.isRepeating && $0.category == income.category })
            for deleteIncome in incomes {
                DataService.shared.delete(income: deleteIncome)
            }
            navigationController?.popViewController(animated: true)
            incomeDelegate?.deleteIncome()
        }
    }
    
    private func showWarning(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.view.tintColor = .appThemeColor
        alertController.addAction(UIAlertAction(title: OK, style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveButton(direction: .up)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveButton(direction: .down)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 8
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func moveButton(direction: Direction) {
        buttonYPosition.constant = CGFloat(direction == .up ? -70 : 0)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations:  {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
}












