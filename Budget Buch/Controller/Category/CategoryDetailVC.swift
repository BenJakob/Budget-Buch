//
//  DetailCategoryVC.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 01.11.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit
import CoreData

class CategoryDetailVC: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CategoryDetailDelegate {
    
    @IBOutlet weak var iconCollectionView: UICollectionView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var iconHeading: UILabel!
    @IBOutlet weak var colorHeading: UILabel!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    private var selectedImage: Int?
    private var selectedColor: Int?
    private var editingCategory: Category?
    
    var configureDelegate: CategoryDelegate?
    var isEditingMode = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = TITLE
        iconHeading.text = SELECT_ICON
        colorHeading.text = SELECT_COLOR
        nameTextField.placeholder = TITLE_PLACEHOLDER
        
        iconCollectionView.delegate = self
        iconCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        segmentController.setTitle(EXPENSE, forSegmentAt: 0)
        segmentController.setTitle(INCOME, forSegmentAt: 1)
    }
        
    func configure(category: Category?) {
        guard let category = category else {
            navigationItem.title = NEW_CATEGORY_TITLE
            segmentController.isEnabled = true
            isEditingMode = false
            return
        }
        navigationItem.title = category.name!
        nameTextField.text = category.name!
        editingCategory = category
        
        if category is IncomeCategory {
            segmentController.selectedSegmentIndex = 1
        }
        segmentController.isEnabled = false
        selectedColor = Int(category.colorIndex)
        selectedImage = Int(category.iconIndex)
        isEditingMode = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        iconCollectionView.reloadData()
        colorCollectionView.reloadData()
        guard let color = selectedColor else { return }
        guard let icon = selectedImage else { return }
        var indexpath = IndexPath(item: color, section: 0)
        colorCollectionView.selectItem(at: indexpath, animated: true, scrollPosition: .centeredHorizontally)
        indexpath = IndexPath(item: icon, section: 0)
        iconCollectionView.selectItem(at: indexpath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let delegate = configureDelegate else { return }
        delegate.deselectRow()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == iconCollectionView ? icons.count : colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == iconCollectionView {
            if let cell = iconCollectionView.dequeueReusableCell(withReuseIdentifier: ICON_CELL_ID, for: indexPath) as? IconCell {
                cell.iconView.image = UIImage(named: icons[indexPath.item])
                return cell
            }
        } else {
            if let cell = colorCollectionView.dequeueReusableCell(withReuseIdentifier: COLOR_CELL_ID, for: indexPath) as? ColorCell {
                cell.colorView.backgroundColor = colors[indexPath.item]
                return cell
            }
        }
        let cell = UICollectionViewCell()
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == iconCollectionView {
            selectedImage = indexPath.item
        } else {
            selectedColor = indexPath.item
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    @IBAction func deleteCategory(_ sender: Any) {
        if isEditingMode {
            if segmentController.selectedSegmentIndex == 0 {
                let entries = DataService.shared.getExpense()
                let repeatingEntries = DataService.shared.getRepeatingExpense()
                let filteredRepeatingEntries = repeatingEntries.filter({ $0.category == editingCategory })
                let filteredEntries = entries.filter({ $0.category == editingCategory })
                if filteredEntries.count > 0 || filteredRepeatingEntries.count > 0 {
                    deleteCategoryAlert()
                } else {
                    navigationController?.popViewController(animated: true)
                    configureDelegate?.deleteCategory()
                }
            } else {
                let entries = DataService.shared.getIncome()
                let repeatingEntries = DataService.shared.getRepeatingIncome()
                let filteredRepeatingEntries = repeatingEntries.filter({ $0.category == editingCategory })
                let filteredEntries = entries.filter( { $0.category == editingCategory })
                if filteredEntries.count > 0 || filteredRepeatingEntries.count > 0 {
                    deleteCategoryAlert()
                } else {
                    navigationController?.popViewController(animated: true)
                    configureDelegate?.deleteCategory()
                }
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveCategory(_ sender: Any) {
        guard let title = nameTextField.text else { showAlert(title: ERROR_TITLE, message: MISSING_TITLE_MESSAGE); return }
        if title.isEmpty { showAlert(title: ERROR_TITLE, message: MISSING_TITLE_MESSAGE); return }
        guard let color = selectedColor else { showAlert(title: ERROR_TITLE, message: MISSING_COLOR_MESSAGE); return }
        guard let icon = selectedImage else { showAlert(title: ERROR_TITLE, message: MISSING_ICON_MESSAGE); return }
        
        if isEditingMode {
            if let category = editingCategory {
                category.name = title
                category.iconIndex = Int32(icon)
                category.colorIndex = Int32(color)
                configureDelegate?.updateTable()
                navigationController?.popViewController(animated: true)
            }
        } else {
            navigationController?.popViewController(animated: true)
            if segmentController.selectedSegmentIndex == 0 {
                let categories = DataService.shared.getExpensesCategories()
                let filteredCategories = categories.filter({ $0.name == title })
                if filteredCategories.count > 0 {
                    showAlert(title: ERROR_TITLE, message: CATEGORY_EXISTS_MESSAGE)
                } else {
                    let newCategory = NSEntityDescription.insertNewObject(forEntityName: EXPENSE_CATEGORY, into: DatabaseController.persistentContainer.viewContext) as! ExpenseCategory
                    newCategory.name = title
                    newCategory.iconIndex = Int32(icon)
                    newCategory.colorIndex = Int32(color)
                    configureDelegate?.insertNewCategory(newCategory)
                }
            } else {
                let categories = DataService.shared.getIncomesCategories()
                let filteredCategories = categories.filter({ $0.name == title })
                if filteredCategories.count > 0 {
                    showAlert(title: ERROR_TITLE, message: CATEGORY_EXISTS_MESSAGE)
                } else {
                    let newCategory = NSEntityDescription.insertNewObject(forEntityName: INCOME_CATEGORY, into: DatabaseController.persistentContainer.viewContext) as! IncomeCategory
                    newCategory.name = title
                    newCategory.iconIndex = Int32(icon)
                    newCategory.colorIndex = Int32(color)
                    configureDelegate?.insertNewCategory(newCategory)
                }
            }
        }
        DatabaseController.saveContext()
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.view.tintColor = .appThemeColor
        alertController.addAction(UIAlertAction(title: OK, style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteCategoryAlert() {
        let alert = UIAlertController(title: DELETE_TITLE, message: DELETE_CATEGORY_MESSAGE, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.view.tintColor = .appThemeColor
        let confirm = UIAlertAction(title: DELETE, style: UIAlertActionStyle.destructive, handler: handleDelete)
        let chancel = UIAlertAction(title: CANCEL, style: UIAlertActionStyle.cancel, handler: nil)
        
        alert.addAction(confirm)
        alert.addAction(chancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func handleDelete(alert: UIAlertAction) {
        if segmentController.selectedSegmentIndex == 0 {
            let category = DataService.shared.getOtherExpenseCategory()
            let entries = DataService.shared.getExpense()
            let repeatingEntries = DataService.shared.getRepeatingExpense()
            let filteredRepeatingEntries = repeatingEntries.filter( { $0.category == editingCategory })
            let filteredEntries = entries.filter({ $0.category == editingCategory })
            for entry in filteredEntries {
                entry.category = category[0]
            }
            for entry in filteredRepeatingEntries {
                entry.category = category[0]
            }
        } else {
            let category = DataService.shared.getOtherIncomeCategory()
            let entries = DataService.shared.getIncome()
            let repeatingEntries = DataService.shared.getRepeatingIncome()
            let filteredRepeatingEntries = repeatingEntries.filter( { $0.category == editingCategory })
            let filteredEntries = entries.filter({ $0.category == editingCategory })
            for entry in filteredEntries {
                entry.category = category[0]
            }
            for entry in filteredRepeatingEntries {
                entry.category = category[0]
            }
        }
        navigationController?.popViewController(animated: true)
        configureDelegate?.deleteCategory()
    }
}
