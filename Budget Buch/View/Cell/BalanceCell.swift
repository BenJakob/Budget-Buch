//
//  BalanceCell.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 30.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

struct BalanceCellData {
    var category: String
    var amount: Double
    var imageName: String
}

class BalanceCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var incomes = [BalanceCellData]()
    var expenses = [BalanceCellData]()
    
    let sectionTitles = [INCOME_TITLE, EXPENSES_TITLE, ""]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.transform = CGAffineTransform(scaleX: -1, y: 1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BalanceResultCell.self, forCellReuseIdentifier: BALANCE_RESULT_CELL_ID)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
    }

    
    func configureCell(incomes: [Entry], expenses: [Entry]) {
        self.incomes = sumByCategory(entries: incomes)
        self.expenses = sumByCategory(entries: expenses)
        tableView.reloadData()
    }
    
    // MARK: - TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return incomes.count
        } else if section == 1 {
            return expenses.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? BalanceDetailCell {
                cell.configureIncomeCell(entry: incomes[indexPath.row])
                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? BalanceDetailCell {
                cell.configureExpenseCell(entry: expenses[indexPath.row])
                return cell
            }
        } else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: BALANCE_RESULT_CELL_ID, for: indexPath) as? BalanceResultCell {
                cell.amount = getTotal()
                cell.backgroundColor = #colorLiteral(red: 0.9685223699, green: 0.9686879516, blue: 0.9685119987, alpha: 1)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    private func sumByCategory(entries: [Entry]) -> [BalanceCellData] {
        var tempItems: [BalanceCellData] = []
        for item in entries {
            if !tempItems.contains(where: { $0.category == item.category!.name! }) {
                let filteredItems = entries.filter({ $0.category == item.category })
                let sum = filteredItems.reduce(0.0, { $0 + $1.amount })
                let newItem = BalanceCellData(category: item.category!.name!, amount: sum, imageName: icons[Int(item.category!.iconIndex)])
                tempItems.append(newItem)
            }
        }
        return tempItems
    }
    
    private func getTotal() -> Double {
        return incomes.reduce(0.0, { $0 + $1.amount }) - expenses.reduce(0.0, { $0 + $1.amount })
    }

}
