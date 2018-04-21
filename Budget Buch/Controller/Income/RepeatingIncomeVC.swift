//
//  RepeatingIncomeVC.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 05.11.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class RepeatingIncomeVC: UITableViewController, RepeatingDelegate {

    var incomes = [RepeatingIncome]()
    var selectedIncome: RepeatingIncome?
    var selectedPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(popViewController))
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewIncome))
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = FIX_INCOMES_TITLE
        navigationItem.backBarButtonItem?.title = FIX_INCOMES_TITLE
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        incomes = DataService.shared.getRepeatingIncome()
    }

    // MARK: - TableView Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? RepeatingEntryCell {
            cell.configureCell(entry: incomes[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIncome = incomes[indexPath.row]
        selectedPath = indexPath
        performSegue(withIdentifier: TO_EDIT_REAPEATING_INCOME, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    // MARK: - RepeatingIncomeDelegate
    func insert(entry: RepeatingEntry) {
        if incomes.count > 1 {
            let scrollIndexPath = IndexPath(row: incomes.count-1, section: 0)
            tableView.scrollToRow(at: scrollIndexPath, at: .middle, animated: true)
        }
        let insertIndexPath = IndexPath(row: incomes.count, section: 0)
        incomes.append(entry as! RepeatingIncome)
        tableView.insertRows(at: [insertIndexPath], with: .automatic)
    }
    
    func delete() {
        guard let path = selectedPath else { return }
        guard let income = selectedIncome else { return }
        tableView.scrollToRow(at: path, at: .middle, animated: true)
        incomes.remove(at: path.row)
        tableView.deleteRows(at: [path], with: .automatic)
        DataService.shared.delete(income: income)
    }
    
    func update() {
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let delegateVC = segue.destination as? EntryDelegateVC else { return }
        if segue.identifier == TO_ADD_REAPEATING_INCOME {
            delegateVC.configureAsNewRepeatingIncomeVC(delegate: self as RepeatingDelegate)
        }
        else if segue.identifier == TO_EDIT_REAPEATING_INCOME {
            delegateVC.configureAsEditRepeatingIncomeVC(income: selectedIncome!, delegate: self as RepeatingDelegate)
        }
    }
 
    @objc private func addNewIncome() {
        performSegue(withIdentifier: TO_ADD_REAPEATING_INCOME, sender: nil)
    }
    
    @objc private func popViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
