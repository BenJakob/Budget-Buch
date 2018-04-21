//
//  IncomeVC.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 26.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit
import GoogleMobileAds

class IncomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var adBanner: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    
    private var sortedEntries: [[Entry]]!
    private var sectionTitles: [String]!
    
    private var selectedEntry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adBanner.adUnitID = INCOMES_AD
        adBanner.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        adBanner.load(request)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NoDataCell.self, forCellReuseIdentifier: NO_DATA_CELL_ID)
        
        setupControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        let entries = DataService.shared.getIncome()
        sortedEntries = DataService.shared.getSortedEntries(entries: entries)
        sectionTitles = DataService.shared.getHeaderData()
        tableView.reloadData()
    }
    
    private func setupControls() {
        let button: UIButton = {
            let button = UIButton()
            button.addTarget(
                self.revealViewController(),
                action: #selector(SWRevealViewController.revealToggle(_:)),
                for: UIControlEvents.touchUpInside
            )
            button.setBackgroundImage(UIImage(named: BURGER_MENU), for: .normal)
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 20).isActive = true
            return button
        }()
        
        let leftBarButton = UIBarButtonItem(customView: button)
        let rightBarButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.title = INCOME_TITLE
    }
    
    // MARK: - TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedEntries.count == 0 ? 1 : sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedEntries.count == 0 ? 1 : sortedEntries[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles.count == 0 ? "" : sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sortedEntries.count == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: NO_DATA_CELL_ID, for: indexPath) as? NoDataCell {
                cell.selectionStyle = .none
                return cell
            }
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? ArchiveCell  {
            cell.configureCell(entry: sortedEntries[indexPath.section][indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sortedEntries.count != 0 {
            selectedEntry = sortedEntries[indexPath.section][indexPath.row]
            performSegue(withIdentifier: TO_EDIT_INCOME, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return sortedEntries.count == 0 ? .none : .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataService.shared.deleteEntry(indexPath: indexPath)
            let entries = DataService.shared.getIncome()
            sortedEntries = DataService.shared.getSortedEntries(entries: entries)
            sectionTitles = DataService.shared.getHeaderData()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sortedEntries.count == 0 ? 0 : 44
    }
    
    // MARK: - Navigation
    @objc private func addButtonPressed() {
        performSegue(withIdentifier: TO_ADD_INCOME, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let entryVC = segue.destination as? EntryDelegateVC else { return }
        if segue.identifier == TO_ADD_INCOME {
            (entryVC as EntryDelegate).configureAsNewIncomeVC()
        } else if segue.identifier == TO_EDIT_INCOME {
            guard let selectedEntry = selectedEntry else { return }
            (entryVC as EntryDelegate).configureAsEditIncomeVC(income: selectedEntry as! Income)
        }
    }
}
