//
//  AddVC.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 12.11.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol AddVCDelegate {
    func configureAsNewExpenseVC()
    func configureAsNewIncomeVC()
    func configureAsEditExpenseVC(expense: Expense)
    func configureAsEditIncomeVC(income: Income)
    func configureAsNewRepeatingExpenseVC(delegate: RepeatingDelegate)
    func configureAsNewRepeatingIncomeVC(delegate: RepeatingDelegate)
    func configureAsEditRepeatingExpenseVC(expense: RepeatingExpense, delegate: RepeatingDelegate)
    func configureAsEditRepeatingIncomeVC(income: RepeatingIncome, delegate: RepeatingDelegate)
    func dismissKeyboard()
}

class AddVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, AddVCDelegate {

    // MARK: - Attributes
    @IBOutlet var selectView: UIView!
    @IBOutlet var selectDateView: UIView!
    
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var adBanner: GADBannerView!
    @IBOutlet weak var receiptImageView: UIImageView!
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var selectViewLabel: UILabel!
    @IBOutlet weak var selectViewDateLabel: UILabel!
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var intervalTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    @IBOutlet weak var adBannerHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    let imageView = UIImageView()
    var categories: [Category]?
    var controllerMode: ControllerMode!
    var selectViewMode: SelectViewMode?
    var selectedItem: String?
    var repeatingDelegate: RepeatingDelegate?
    var editEntry: Entry?
    
    let visualEffect: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .extraLight)
        let vibrancy = UIVibrancyEffect(blurEffect: blur)
        let visualEffectView = UIVisualEffectView(effect: blur)
        return visualEffectView
    }()
    
    // MARK: - Setup Views
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTextFields()
        
        if UIDevice.current.modelName == "iPhone X" || UIDevice.current.modelName.hasSuffix("Plus") {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    private func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(IntervalCell.self, forCellReuseIdentifier: INTERVALL_CELL_ID)
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        selectView.layer.cornerRadius = 5
        selectView.translatesAutoresizingMaskIntoConstraints = false
        
        selectDateView.layer.cornerRadius = 5
        selectDateView.translatesAutoresizingMaskIntoConstraints = false
        
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.cornerRadius = 5
        notesTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        buttonView.layer.cornerRadius = buttonView.frame.size.height / 2
        receiptImageView.layer.cornerRadius = 5
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = view.bounds
        visualEffect.frame = view.bounds
        imageView.addSubview(visualEffect)
        
        endDateLabel.isHidden = true
        endDateTextField.isHidden = true
        seperatorView.isHidden = true
        
        adBanner.adUnitID = NEW_EXPENSE_AD
        adBanner.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        adBanner.load(request)
    }
    
    private func setupTextFields() {
        startDateLabel.text = DATE
        intervalLabel.text = INTERVAL
        categoryLabel.text = CATEGORY
        amountLabel.text = AMOUNT
        endDateLabel.text = END_DATE
        
        startDateTextField.text = DateFormatter.customFormatter.string(from: Date())
        intervalTextField.text = NONE
        endDateTextField.placeholder = OPTIONAL
        categoryTextField.placeholder = SELECTCATEGORY
        amountTextField.placeholder = NumberFormatter.currencyFormatter.string(from: 0.0)
        
        startDateTextField.tintColor = .clear
        intervalTextField.tintColor = .clear
        categoryTextField.tintColor = .clear
        
        endDateTextField.clearButtonMode = .always
        amountTextField.clearButtonMode = .whileEditing
        amountTextField.keyboardType = .decimalPad
        
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        amountTextField.inputAccessoryView = KeyboardAccessoryView(frame: rect, controllerDelegate: self as AddVCDelegate)
        notesTextView.inputAccessoryView = KeyboardAccessoryView(frame: rect, controllerDelegate: self as AddVCDelegate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch controllerMode {
        case .addExpense, .editExpense:
            categories = DataService.shared.getExpensesCategories()
            break
        case .addIncome, .editIncome:
            categories = DataService.shared.getIncomesCategories()
            break
        default: break
        }
    }
    
    // MARK: - Configure ViewController
    func configureAsNewExpenseVC() {
        navigationItem.title = NEW_EXPENSE_ENTRY
        controllerMode = .addExpense
    }
    
    func configureAsNewIncomeVC() {
        navigationItem.title = NEW_INCOME_ENTRY
        controllerMode = .addIncome
    }
    
    func configureAsEditExpenseVC(expense: Expense) {
        navigationItem.title = EDIT_EXPENSE_ENTRY
        controllerMode = .editExpense
        categoryTextField.text = expense.category?.name
        amountTextField.text = String(expense.amount)
        intervalTextField.text = NONE
        startDateTextField.text = DateFormatter.customFormatter.string(from: expense.date!)
        notesTextView.text = expense.notes
        startDateLabel.text = DATE
        intervalTextField.isEnabled = false
        endDateLabel.isHidden = true
        endDateTextField.isHidden = true
        seperatorView.isHidden = true
        editEntry = expense
    }
    
    func configureAsEditIncomeVC(income: Income) {
        navigationItem.title = EDIT_INCOME_ENTRY
        controllerMode = .editIncome
        categoryTextField.text = income.category?.name
        amountTextField.text = String(income.amount)
        intervalTextField.text = NONE
        startDateTextField.text = DateFormatter.customFormatter.string(from: income.date!)
        notesTextView.text = income.notes
        startDateLabel.text = DATE
        intervalTextField.isEnabled = false
        endDateLabel.isHidden = true
        endDateTextField.isHidden = true
        seperatorView.isHidden = true
        editEntry = income
    }
    
    func configureAsNewRepeatingExpenseVC(delegate: RepeatingDelegate) {
        navigationItem.title = NEW_FIX_EXPENSE_TITLE
        controllerMode = .addRepeatingExpense
        repeatingDelegate = delegate
    }
    
    func configureAsNewRepeatingIncomeVC(delegate: RepeatingDelegate) {
        navigationItem.title = NEW_FIX_INCOME_TITLE
        controllerMode = .addRepeatingIncome
        repeatingDelegate = delegate
    }
    
    func configureAsEditRepeatingExpenseVC(expense: RepeatingExpense, delegate: RepeatingDelegate) {
        navigationItem.title = EDIT_EXPENSE_ENTRY
        controllerMode = .editRepeatingExpense
        categoryTextField.text = expense.category?.name
        amountTextField.text = String(expense.amount)
        intervalTextField.text = NONE
        startDateTextField.text = DateFormatter.customFormatter.string(from: expense.date!)
        if let endDate = expense.endDate {
            endDateTextField.text = DateFormatter.customFormatter.string(from: endDate)
        }
        notesTextView.text = expense.notes
        startDateLabel.text = START_DATE
        intervalTextField.isEnabled = true
        endDateLabel.isHidden = false
        endDateTextField.isHidden = false
        seperatorView.isHidden = false
        editEntry = expense
        repeatingDelegate = delegate
    }
    
    func configureAsEditRepeatingIncomeVC(income: RepeatingIncome, delegate: RepeatingDelegate) {
        navigationItem.title = EDIT_INCOME_ENTRY
        controllerMode = .editRepeatingIncome
        categoryTextField.text = income.category?.name
        amountTextField.text = String(income.amount)
        intervalTextField.text = NONE
        startDateTextField.text = DateFormatter.customFormatter.string(from: income.date!)
        if let endDate = income.endDate {
            endDateTextField.text = DateFormatter.customFormatter.string(from: endDate)
        }
        notesTextView.text = income.notes
        startDateLabel.text = START_DATE
        intervalTextField.isEnabled = true
        endDateLabel.isHidden = false
        endDateTextField.isHidden = false
        seperatorView.isHidden = false
        editEntry = income
        repeatingDelegate = delegate
    }
    
    // MARK: - Text Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField {
        case categoryTextField:
            self.view.endEditing(true)
            selectViewMode = .category
            selectViewLabel.text = CATEGORY_TITLE
            tableView.reloadData()
            showSelectView(selectView)
            disableAllItems()
            return false
        case intervalTextField:
            self.view.endEditing(true)
            selectViewMode = .interval
            selectViewLabel.text = INTERVAL_TITLE
            tableView.reloadData()
            showSelectView(selectView)
            disableAllItems()
            return false
        case amountTextField:
            return true
        case startDateTextField:
            self.view.endEditing(true)
            selectViewMode = .startDate
            selectViewDateLabel.text = START
            selectedItem = DateFormatter.customFormatter.string(from: datePicker.date)
            showSelectView(selectDateView)
            disableAllItems()
            return false
        case endDateTextField:
            self.view.endEditing(true)
            selectViewMode = .endDate
            selectViewDateLabel.text = END
            selectedItem = DateFormatter.customFormatter.string(from: datePicker.date)
            showSelectView(selectDateView)
            disableAllItems()
            return false
        default:
            return true
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.contentView.frame.origin.y = 0
        })
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.contentView.frame.origin.y = -160
        })
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.contentView.frame.origin.y = 0
        })
        return true
    }
    
    // MARK: - Action
    @IBAction func addPhotoButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if isValidInput() {
            switch controllerMode {
            case .addIncome, .addExpense:
                saveNewEntry()
                break
            case .editIncome, .editExpense:
                edit()
                break
            case .addRepeatingIncome, .addRepeatingExpense:
                break
            case .editRepeatingIncome, .editRepeatingExpense:
                break
            default:
                break
            }
        } else {
            showWarning(title: ERROR_TITLE, message: EMPTY_FIELD_MESSAGE)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveSelectPressed(_ sender: UIButton) {
        guard let selectedItem = selectedItem else { return }
        guard let selectViewMode = selectViewMode else { return }
        
        switch selectViewMode {
        case .category:
            categoryTextField.text = selectedItem
            hideSelectView(selectView)
            break
        case .interval:
            intervalTextField.text = selectedItem
            if selectedItem != NONE {
                UIView.animate(withDuration: 0.5, animations: {
                    self.endDateLabel.isHidden = false
                    self.endDateTextField.isHidden = false
                    self.seperatorView.isHidden = false
                    self.startDateLabel.text = START_DATE
                })
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.endDateLabel.isHidden = true
                    self.endDateTextField.isHidden = true
                    self.seperatorView.isHidden = true
                    self.startDateLabel.text = DATE
                })
                endDateTextField.text = ""
            }
            hideSelectView(selectView)
            break
        case .startDate:
            startDateTextField.text = selectedItem
            hideSelectView(selectDateView)
            break
        case .endDate:
            endDateTextField.text = selectedItem
            hideSelectView(selectDateView)
            break
        }
        self.selectedItem = ""
    }
        
    @IBAction func cancelSelectPressed(_ sender: UIButton) {
        guard let selectViewMode = selectViewMode else { return }
        switch selectViewMode {
        case .category, .interval:
            hideSelectView(selectView)
            break
        case .startDate, .endDate:
            hideSelectView(selectDateView)
            break
        }
        selectedItem = ""
    }
    
    // MARK: - SelectView Functions
    private func showSelectView(_ selectView: UIView) {
        getScreenShot()
        self.view.addSubview(imageView)
        self.view.addSubview(selectView)
        setSelectViewConstraints()
        selectView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        selectView.alpha = 0
        imageView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.imageView.alpha = 1
            selectView.alpha = 1
            selectView.transform = CGAffineTransform.identity
        }
    }
    
    @objc func hideSelectView(_ selectView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            selectView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            selectView.alpha = 0
            self.imageView.alpha = 0
        }) { (success: Bool) in
            self.enableAllItems()
            selectView.removeFromSuperview()
            self.imageView.removeFromSuperview()
        }
    }
    
    private func getScreenShot() {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 1)
        self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func disableAllItems() {
        categoryTextField.isEnabled = false
        intervalTextField.isEnabled = false
        amountTextField.isEnabled = false
        startDateTextField.isEnabled = false
        endDateTextField.isEnabled = false
        adBannerHeight.constant = 0
    }
    
    private func enableAllItems() {
        categoryTextField.isEnabled = true
        intervalTextField.isEnabled = true
        amountTextField.isEnabled = true
        startDateTextField.isEnabled = true
        endDateTextField.isEnabled = true
        adBannerHeight.constant = 50
    }
    
    // MARK: - TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectViewMode = selectViewMode else { return 0 }
        guard let categories = categories else { return 0 }
        return selectViewMode == .category ? categories.count : intervalData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let selectViewMode = selectViewMode else { return UITableViewCell() }
        if selectViewMode == .category {
            guard let categories = categories else { return UITableViewCell() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? CategoryCell else { return UITableViewCell() }
            cell.configureCell(data: categories[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: INTERVALL_CELL_ID, for: indexPath) as? IntervalCell else { return UITableViewCell() }
            cell.title = intervalData[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectViewMode = selectViewMode else { return }
        if selectViewMode == .category {
            guard let categories = categories else { return }
            selectedItem = categories[indexPath.row].name
        } else {
            selectedItem = intervalData[indexPath.row]
        }
    }
    
    @objc func dateChanged() {
        selectedItem = DateFormatter.customFormatter.string(from: datePicker.date)
    }
    
    // MARK: - Save Data
    private func isValidInput() -> Bool {
        guard let date = startDateTextField.text else { return false }
        guard let category = categoryTextField.text else { return false }
        guard let interval = intervalTextField.text else { return false }
        guard let amount = amountTextField.text else { return false }
        guard (notesTextView.text != nil) else { return false }
        guard (DateFormatter.customFormatter.date(from: date) != nil) else { return false }
        guard (NumberFormatter.decimalFormatter.number(from: amount) != nil) else { return false }
        
        let categories = DataService.shared.getCategory(byName: category)
        if categories.count <= 0 { return false }
        
        if date.isEmpty || category.isEmpty || interval.isEmpty || amount.isEmpty { return false }
        
        return true
    }
    
    private func saveNewEntry() {
        if intervalTextField.text! == NONE {
            if controllerMode == .addExpense {
                DatabaseController.insertExpense(category: categoryTextField.text!, date: startDateTextField.text!, amount: amountTextField.text!, isRepeating: false, notes: notesTextView.text)
            } else if controllerMode == .addIncome {
                DatabaseController.insertIncome(category: categoryTextField.text!, date: startDateTextField.text!, amount: amountTextField.text!, isRepeating: false, notes: notesTextView.text)
            }
            self.dismiss(animated: true, completion: nil)
        } else {
            let repeatingEntries = controllerMode == .addExpense ? DataService.shared.getRepeatingExpense() as [Entry] : DataService.shared.getRepeatingIncome() as [Entry]
            let filteredEntries = repeatingEntries.filter({ $0.category?.name == categoryTextField.text! })
            if filteredEntries.count > 0 {
                if controllerMode == .addExpense { showWarning(title: ERROR_TITLE, message: EXPENSE_EXISTS_MESSAGE) }
                else if controllerMode == .addIncome { showWarning(title: ERROR_TITLE, message: INCOME_EXISTS_MESSAGE) }
            } else {
                guard let startDate = DateFormatter.customFormatter.date(from: startDateTextField.text!) else { return }
                guard let currentDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return }
                
                if startDate < currentDate {
                    showAutoFillAlert()
                } else {
                    if controllerMode == .addExpense { insertExpense(beginAt: currentDate) }
                    else if controllerMode == .addIncome { insertIncome(beginAt: currentDate) }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func edit() {
        let categories = DataService.shared.getCategory(byName: categoryTextField.text!)
        if categories.count > 0 {
            guard let editEntry = editEntry else { return }
            editEntry.date = DateFormatter.customFormatter.date(from: startDateTextField.text!)
            editEntry.category = categories[0]
            editEntry.amount = Double(truncating: NumberFormatter.decimalFormatter.number(from: amountTextField.text!)!)

            if editEntry is RepeatingEntry {
                let editRepeatingEntry = editEntry as! RepeatingEntry
                editRepeatingEntry.interval = intervalTextField.text!
                if let endDate = endDateTextField.text {
                    editRepeatingEntry.endDate = DateFormatter.customFormatter.date(from: endDate)
                    repeatingDelegate?.update()
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
        DatabaseController.saveContext()
    }
    
    private func insertExpense(beginAt date: Date) {
        if let newExpense = DatabaseController.insertRepeatingExpense(
            category: self.categoryTextField.text!,
            startDate: self.startDateTextField.text!,
            endDate: self.endDateTextField.text,
            amount: self.amountTextField.text!,
            interval: self.intervalTextField.text!,
            notes: self.notesTextView.text) {
            DatabaseController.insertMissingRepeatingExpenses([newExpense], beginAt: date)
        }
    }
    
    private func insertIncome(beginAt date: Date) {
        if let newIncome = DatabaseController.insertRepeatingIncome(
            category: self.categoryTextField.text!,
            startDate: self.startDateTextField.text!,
            endDate: self.endDateTextField.text,
            amount: self.amountTextField.text!,
            interval: self.intervalTextField.text!,
            notes: self.notesTextView.text) {
            DatabaseController.insertMissingRepeatingIncomes([newIncome], beginAt: date)
        }
    }
    
    // MARK: - AlertViews
    private func showAutoFillAlert() {
        let alertController = UIAlertController(title: AUTOFILL_TITLE, message: AUTOFILL_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
        alertController.view.tintColor = .appThemeColor
        alertController.addAction(UIAlertAction(title: AUTOFILL_YES, style: .default, handler: { (action) in
            if self.controllerMode == .addExpense { self.insertExpense(beginAt: DateFormatter.customFormatter.date(from: self.startDateTextField.text!)!) }
            else if self.controllerMode == .addIncome { self.insertIncome(beginAt: DateFormatter.customFormatter.date(from: self.startDateTextField.text!)!) }
            self.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: AUTOFILL_NO, style: .default, handler: { (action) in
            if self.controllerMode == .addExpense { self.insertExpense(beginAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!) }
            else if self.controllerMode == .addIncome { self.insertIncome(beginAt: Calendar.current.date(byAdding: .day, value: -1, to: Date())!) }
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showWarning(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.view.tintColor = .appThemeColor
        alertController.addAction(UIAlertAction(title: OK, style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Set SelectView Constraints
    private func setSelectViewConstraints() {
        guard let selectViewMode = selectViewMode else { return }
        switch selectViewMode {
        case .category, .interval:
            NSLayoutConstraint.activate([
                selectView.heightAnchor.constraint(equalToConstant: 400),
                selectView.widthAnchor.constraint(equalToConstant: 240),
                selectView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                selectView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
            break
        case .startDate, .endDate:
            NSLayoutConstraint.activate([
                selectDateView.heightAnchor.constraint(equalToConstant: 300),
                selectDateView.widthAnchor.constraint(equalToConstant: 280),
                selectDateView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                selectDateView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
                ])
            break
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}

