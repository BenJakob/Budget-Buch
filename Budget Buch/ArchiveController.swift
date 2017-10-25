//
//  ArchiveController.swift
//  Haushaltsbuch
//
//  Created by Benjamin Jakob on 21.10.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//

import UIKit
import CoreData

class ArchiveController: UITableViewController {
    
    // MARK: - Attributes
    private var isIncome = true
    private var sortedEntries: [[Entry]]!
    private var headerTitles: [String]!
    
    
    init(style: UITableViewStyle, isIncome: Bool) {
        super.init(style: style)
        self.isIncome = isIncome
        self.isIncome ? (navigationItem.title = "Ausgaben") : (navigationItem.title = "Einnahmen")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - TableViewFunctions
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addEntry)
        )
        sortedEntries = loadEntries()
        headerTitles = DataService.instance.getHeaderData()
        
        navigationItem.rightBarButtonItem = addButton
        view.backgroundColor = .white
        tableView.register(ArchiveCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(NoDataCell.self, forCellReuseIdentifier: "noDataCellId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sortedEntries = loadEntries()
        headerTitles = DataService.instance.getHeaderData()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortedEntries.count + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if sortedEntries.count == 0 {
                return 1
            } else {
                return 0
            }
        } else {
            return sortedEntries[section - 1].count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ArchiveCell
            cell.updateData(cellData: sortedEntries[indexPath.section - 1][indexPath.row])
            cell.selectionStyle = .none
            cell.accessoryType = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "noDataCellId", for: indexPath) as! NoDataCell
        cell.isUserInteractionEnabled = false
        cell.accessoryType = .none
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section != 0 {
            return .delete
        }
        return .none
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            if editingStyle == .delete {
                DataService.instance.deleteEntry(indexPath: indexPath)
                sortedEntries = loadEntries()
                headerTitles = DataService.instance.getHeaderData()
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    // MARK: - Supporting Functions
    private func loadEntries() -> [[Entry]]{
        if isIncome {
            return DataService.instance.getIncomeEntries()
        } else {
            return DataService.instance.getExpenseEntries()
        }
    }
    
    @objc private func addEntry() {
        let addController = AddController(style: .grouped, isIncome: isIncome, controller: self)
        navigationController?.pushViewController(addController, animated: true)
        tableView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    //    func showSuccess() {
    //        var message = ""
    //        isIncome ? (message = "Einnahme") : (message = "Ausgabe")
    //        let alertController = UIAlertController(title: "Bussi", message: "\(message) gespeichert. 😘😍😘 Als Belohnung!", preferredStyle: UIAlertControllerStyle.alert)
    //        alertController.view.tintColor = .appThemeColor
    //        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    //        self.present(alertController, animated: true, completion: nil)
    //    }
}
