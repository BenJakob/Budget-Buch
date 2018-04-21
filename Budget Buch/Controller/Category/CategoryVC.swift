//
//  CategoryVC.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 01.11.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CategoryVC: UITableViewController, CategoryDelegate {

    private var detailCategoryDelegate: CategoryDetailDelegate?
    private var categories = [[Category]]()
    private var sectionTitles = [EXPENSES_TITLE, INCOME_TITLE]
    private var selectedRow: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = CATEGORY_TITLE
        
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(popViewController))
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewCategoryController))
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
        navigationController?.navigationBar.prefersLargeTitles = true
        
        var fetchedCategories = DataService.shared.getExpensesCategories()
        fetchedCategories = fetchedCategories.filter({ type(of: $0) == ExpenseCategory.self })
        categories.append(fetchedCategories)
        
        fetchedCategories = DataService.shared.getIncomesCategories()
        fetchedCategories = fetchedCategories.filter({ type(of: $0) == IncomeCategory.self })
        categories.append(fetchedCategories)
    }
    
    // MARK: - TableView Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? CategoryCell {
            cell.configureCell(data: categories[indexPath.section][indexPath.row])
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: TO_CATEGORY_DETAIL, sender: nil)
        detailCategoryDelegate?.configure(category: categories[indexPath.section][indexPath.row])
        selectedRow = indexPath
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_CATEGORY_DETAIL {
            guard let detailVC = segue.destination as? CategoryDetailVC else { return }
            detailVC.configureDelegate = self
            detailCategoryDelegate = detailVC
            let _ = detailVC.view
        }
    }
    
    @objc private func popViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func showNewCategoryController() {
        performSegue(withIdentifier: TO_CATEGORY_DETAIL, sender: nil)
        detailCategoryDelegate?.configure(category: nil)
    }
    
    func deselectRow() {
        if let row = selectedRow {
            tableView.deselectRow(at: row, animated: false)
        }
    }
    
    func insertNewCategory(_ category: Category) {
        if category is ExpenseCategory {
            if categories[0].count > 1 {
                let scrollIndexPath = IndexPath(row: categories[0].count-1, section: 0)
                tableView.scrollToRow(at: scrollIndexPath, at: .middle, animated: true)
            }
            let insertIndexPath = IndexPath(row: categories[0].count, section: 0)
            categories[0].append(category)
            tableView.insertRows(at: [insertIndexPath], with: .automatic)
        } else {
            if categories[0].count > 1 {
                let scrollIndexPath = IndexPath(row: categories[1].count-1, section: 1)
                tableView.scrollToRow(at: scrollIndexPath, at: .middle, animated: true)
            }
            let insertIndexPath = IndexPath(row: categories[1].count, section: 1)
            categories[1].append(category)
            tableView.insertRows(at: [insertIndexPath], with: .automatic)
        }
    }
    
    func deleteCategory() {
        guard let indexPath = selectedRow else { return }
        DataService.shared.delete(category: categories[indexPath.section][indexPath.row])
        categories[indexPath.section].remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func updateTable() {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
