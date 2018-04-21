//
//  SettingsVC.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 26.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SettingsDelegate {

    @IBOutlet weak var tableView: UITableView!
    private var selectedRow: IndexPath?
    
    let rowData = [["Remove Ads (coming soon)", "Restore Purchase (coming soon)"], ["Manage fixed Income", "Manage fix Expenses"], ["Configure Categories", "Configure Statistics"], ["Privacy", "Support"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rowData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? SettingsCell {
            cell.configureCell(labelName: rowData[indexPath.section][indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath
        
        if indexPath.section == 1 && indexPath.row == 0 {
            performSegue(withIdentifier: TO_CONFIG_REPEATING_INCOMES, sender: nil)
        }
        else if indexPath.section == 1 && indexPath.row == 1 {
            performSegue(withIdentifier: TO_CONFIG_REPEATING_EXPENSES, sender: nil)
        }
        else if indexPath.section == 2 && indexPath.row == 0 {
            performSegue(withIdentifier: TO_CONFIG_CATEGORIES, sender: nil)
        }
        else if indexPath.section == 2 && indexPath.row == 1 {
            performSegue(withIdentifier: TO_CONFIG_STATISTICS, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? DelegateVC else { return }
        destVC.settingsDelegate = self
    }
    
    func deselectRow() {
        if let row = selectedRow {
            tableView.deselectRow(at: row, animated: true)
        }
    }
}
