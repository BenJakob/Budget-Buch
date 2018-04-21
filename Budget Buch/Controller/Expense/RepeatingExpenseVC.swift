//
//  RepeatingExpenseVC.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 07.11.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class RepeatingExpenseVC: UITableViewController, RepeatingDelegate {
    
    var expenses = [RepeatingExpense]()
    var selectedExpense: RepeatingExpense?
    var selectedPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(popViewController))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewExpense))
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = FIX_EXPENSES_TITLE
        navigationItem.backBarButtonItem?.title = FIX_EXPENSES_TITLE
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        expenses = DataService.shared.getRepeatingExpense()
    }
    
    // MARK: - TableView Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? RepeatingEntryCell {
            cell.configureCell(entry: expenses[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedExpense = expenses[indexPath.row]
        selectedPath = indexPath
        performSegue(withIdentifier: TO_EDIT_REAPEATING_EXPENSE, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    // MARK: - RepeatingExpenseDelegate
    func insert(entry: RepeatingEntry) {
        if expenses.count > 1 {
            let scrollIndexPath = IndexPath(row: expenses.count-1, section: 0)
            tableView.scrollToRow(at: scrollIndexPath, at: .middle, animated: true)
        }
        let insertIndexPath = IndexPath(row: expenses.count, section: 0)
        expenses.append(entry as! RepeatingExpense)
        tableView.insertRows(at: [insertIndexPath], with: .automatic)
    }
    
    func delete() {
        guard let path = selectedPath else { return }
        guard let expense = selectedExpense else { return }
        tableView.scrollToRow(at: path, at: .middle, animated: true)
        expenses.remove(at: path.row)
        tableView.deleteRows(at: [path], with: .automatic)
        DataService.shared.delete(expense: expense)
    }
    
    func update() {
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let delegateVC = segue.destination as? EntryDelegateVC else { return }
        if segue.identifier == TO_ADD_REAPEATING_EXPENSE {
            delegateVC.configureAsNewRepeatingExpenseVC(delegate: self as RepeatingDelegate)
        }
        else if segue.identifier == TO_EDIT_REAPEATING_EXPENSE {
            delegateVC.configureAsEditRepeatingExpenseVC(expense: selectedExpense!, delegate: self as RepeatingDelegate)
        }
    }
    
    @objc private func addNewExpense() {
        performSegue(withIdentifier: TO_ADD_REAPEATING_EXPENSE, sender: nil)
    }
    
    @objc private func popViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
