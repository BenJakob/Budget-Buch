//
//  NewExpenseVC.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 27.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NewExpenseVC: UIViewController, UITextFieldDelegate, NewEntryDelegate {
    
    @IBOutlet weak var adBanner: GADBannerView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var intervalTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var amountTextField: CurrencyTextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var endDateHeight: NSLayoutConstraint!
    @IBOutlet weak var seperatorHeight: NSLayoutConstraint!
    @IBOutlet weak var saveButton: SaveButton!
    @IBOutlet weak var viewBottomAnchor: NSLayoutConstraint!
    
    let moveConstant = 29
    var isExpandedStackview = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NEW_EXPENSE_ENTRY
        
        adBanner.adUnitID = NEW_EXPENSE_AD
        adBanner.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        adBanner.load(request)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        configureTextFields()
        
        if UIDevice.current.modelName == "iPhone SE" {
            let alternativeSaveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(safe))
            navigationItem.rightBarButtonItem = alternativeSaveButton
            saveButton.isHidden = true
        }
        
        endDateHeight.constant = 0
        seperatorHeight.constant = 0
        viewBottomAnchor.constant = CGFloat(moveConstant)
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let categories = DataService.shared.getExpensesCategories()
        var categoryNames = [String]()
        categoryNames.append("")
        for category in categories {
            categoryNames.append(category.name!)
        }
        _ = CustomPicker(textField: categoryTextField, data: categoryNames)
    }
    
    private func configureTextFields() {
        dateLabel.text = DATE
        intervalLabel.text = INTERVAL
        categoryLabel.text = CATEGORY
        amountLabel.text = AMOUNT
        endDateLabel.text = END_DATE
        
        dateTextField.text = DateFormatter.customFormatter.string(from: Date())
        intervalTextField.text = NONE
        endDateTextField.placeholder = OPTIONAL
        categoryTextField.placeholder = SELECTCATEGORY
        amountTextField.placeholder = NumberFormatter.currencyFormatter.string(from: 0.0)
        
        dateTextField.tintColor = .clear
        intervalTextField.tintColor = .clear
        categoryTextField.tintColor = .clear
        
        endDateTextField.clearButtonMode = .whileEditing
        amountTextField.clearButtonMode = .whileEditing
        amountTextField.keyboardType = .decimalPad

        _ = DatePicker(textField: dateTextField)
        _ = DatePicker(textField: endDateTextField)
        _ = IntervalPicker(textField: intervalTextField, data: intervalData, delegate: self as NewEntryDelegate)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        safe()
    }
    
    @objc private func safe(){
        guard let date = dateTextField.text else { return }
        guard let category = categoryTextField.text else { return }
        guard let interval = intervalTextField.text else { return }
        guard let amount = amountTextField.text else { return }
        
        if date.isEmpty || category.isEmpty || interval.isEmpty || amount.isEmpty {
            showWarning()
        } else {
            let categories = DataService.shared.getCategory(byName: category)
            if categories.count > 0 {
                if interval == NONE {
                    DatabaseController.insertEntry(forEntityName: EXPENSE, as: .expense, category: categories[0], date: date, amount: amount, interval: interval)
                } else {
                    let expenses = DataService.shared.getRepeatingExpense()
                    let filteredExpenses = expenses.filter({ $0.category?.name == category })
                    if filteredExpenses.count > 0 {
                        showWarning(title: ERROR_TITLE, message: EXPENSE_EXISTS_MESSAGE)
                    } else {
                        if let startDate = DateFormatter.customFormatter.date(from: date) {
                            let currentDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
                            if startDate < currentDate! {
                                let alertController = UIAlertController(title: AUTOFILL_TITLE, message: AUTOFILL_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
                                alertController.view.tintColor = .appThemeColor
                                alertController.addAction(UIAlertAction(title: AUTOFILL_YES, style: .default, handler: { (action) in
                                    if let newExpense = DatabaseController.insertRepeatingExpense(category: categories[0], startDate: date, endDate: self.endDateTextField.text, amount: amount, interval: interval) {
                                        DatabaseController.insertMissingRepeatingExpenses([newExpense], beginAt: startDate)
                                    }
                                    self.navigationController?.popViewController(animated: true)
                                }))
                                alertController.addAction(UIAlertAction(title: AUTOFILL_NO, style: .default, handler: { (action) in
                                    if let newExpense = DatabaseController.insertRepeatingExpense(category: categories[0], startDate: date, endDate: self.endDateTextField.text, amount: amount, interval: interval) {
                                        DatabaseController.insertMissingRepeatingExpenses([newExpense], beginAt: Date())
                                    }
                                    self.navigationController?.popViewController(animated: true)
                                }))
                                self.present(alertController, animated: true, completion: nil)
                            } else {
                                if let newExpense = DatabaseController.insertRepeatingExpense(category: categories[0], startDate: date, endDate: self.endDateTextField.text, amount: amount, interval: interval) {
                                    DatabaseController.insertMissingRepeatingExpenses([newExpense], beginAt: Date())
                                }
                            }
                        }
                    }
                }
            }
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    private func showWarning() {
        let alertController = UIAlertController(title: ERROR_TITLE, message: EMPTY_FIELD_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
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
    
    func updateConstraints() {
        if intervalTextField.text != NONE {
            isExpandedStackview = true
            dateLabel.text = START_DATE
            endDateHeight.constant = 21
            seperatorHeight.constant = 1
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations:  {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            isExpandedStackview = false
            dateLabel.text = DATE
            endDateHeight.constant = 0
            seperatorHeight.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations:  {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 8
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func moveButton(direction: Direction) {
        if isExpandedStackview {
            viewBottomAnchor.constant = CGFloat(direction == .up ? 58 : 0)
        } else {
            viewBottomAnchor.constant = CGFloat(direction == .up ? 58 : moveConstant)
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations:  {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func showWarning(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.view.tintColor = .appThemeColor
        alertController.addAction(UIAlertAction(title: OK, style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

