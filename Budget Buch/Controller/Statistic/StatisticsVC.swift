//
//  StatisticsVC.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 26.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit
import GoogleMobileAds

class StatisticsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, StatisticsVCDelegate {
    
    @IBOutlet weak var adBanner: GADBannerView!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var amountHeight: NSLayoutConstraint!
    @IBOutlet weak var totalAmountHeight: NSLayoutConstraint!
    @IBOutlet weak var distanceToAd: NSLayoutConstraint!
    
    var currentPageNumber = 0
    
    private var entries = [Entry]()
    private var balanceEntries = [[Entry]]()
    private var isBlanceSelected = false
    private var displayMode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adBanner.adUnitID = DIAGRAMS_AD
        adBanner.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        //"848100210029b2821ef9e43836a9fbac"
        adBanner.load(request)
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(exportData))
        navigationItem.rightBarButtonItem = shareButton
        navigationController?.navigationBar.prefersLargeTitles = false
        
        currentPageNumber = 0
        setupControls()
        rightButton.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.transform = CGAffineTransform(scaleX: -1, y: 1)
        collectionView.register(DiagramCell.self, forCellWithReuseIdentifier: DIAGRAM_CELL_ID)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        displayMode = UserDefaults.standard.getInterval()
        if displayMode == MONTHLY {
            dateLabel.text = "\(getMonth(byIndex: currentPageNumber)) \(getYear(byIndex: currentPageNumber))"
        } else {
            dateLabel.text = getYear(byIndex: currentPageNumber)
        }

        switch segmentedController.selectedSegmentIndex {
        case 0:
            entries = DataService.shared.getExpense()
            setTotalAmount(pagenumber: currentPageNumber)
            collectionView.reloadData()
            break
        case 1:
            entries = DataService.shared.getIncome()
            setTotalAmount(pagenumber: currentPageNumber)
            collectionView.reloadData()
            break
        case 2:
            balanceEntries = [[Entry]]()
            balanceEntries.append(DataService.shared.getIncome())
            balanceEntries.append(DataService.shared.getExpense())
            collectionView.reloadData()
            break
        default:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        amountLabel.isHidden = true
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
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.title = STATISTICS_TITLE
        
        segmentedController.setTitle(EXPENSES_TITLE, forSegmentAt: 0)
        segmentedController.setTitle(INCOME_TITLE, forSegmentAt: 1)
        segmentedController.setTitle(BALANCE_LABEL, forSegmentAt: 2)
        
        amountLabel.isHidden = true
    }
    
    // MARK: - CollectionView Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 36
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isBlanceSelected {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BALANCE_CELL_ID, for: indexPath) as? BalanceCell {
                let filteredIncomes = filterEntries(byIndex: indexPath.item, entries: balanceEntries[0])
                let filteredExpenses = filterEntries(byIndex: indexPath.item, entries: balanceEntries[1])
                cell.configureCell(incomes: filteredIncomes, expenses: filteredExpenses)
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DIAGRAM_CELL_ID, for: indexPath) as? DiagramCell {
                let filteredEntries = filterEntries(byIndex: indexPath.item, entries: entries)
                cell.configureCell(data: filteredEntries)
                cell.diagramDelegate = self
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        currentPageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        setLabelsToNewPage()
    }
    
    // MARK: - Diagram Delegate
    func setAmount(category: String, amount: Double) {
        let attributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)]
        let attributedTitle = NSMutableAttributedString(string: category + ": ", attributes: attributes)
        attributedTitle.append(NSAttributedString(string: NumberFormatter.currencyFormatter.string(from: amount as NSNumber)!))
        amountLabel.attributedText = attributedTitle
        amountLabel.isHidden = false
    }
    
    func hideAmount() {
        amountLabel.isHidden = true
    }
    
    // MARK: - Supporting Functions
    func setTotalAmount(pagenumber: Int) {
        let filteredEntries = filterEntries(byIndex: pagenumber, entries: entries)
        let totalAmount = filteredEntries.reduce(0, { $0 + $1.amount })
        let attributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)]
        let attributedTitle = NSMutableAttributedString(string: TOTAL + ": ", attributes: attributes)
        attributedTitle.append(NSAttributedString(string: NumberFormatter.currencyFormatter.string(from: totalAmount as NSNumber)!))
        totalAmountLabel.attributedText = attributedTitle
    }
    
    func filterEntries(byIndex index: Int, entries: [Entry]) -> [Entry] {
        if displayMode == MONTHLY {
            return entries.filter {
                DateFormatter.monthFormatter.string(from: (($0 as Entry).date! as Date)) == getMonth(byIndex: index) &&
                DateFormatter.yearFormatter.string(from: (($0 as Entry).date! as Date)) == getYear(byIndex: index)
            }
        } else {
            return entries.filter { DateFormatter.yearFormatter.string(from: (($0 as Entry).date! as Date)) == getYear(byIndex: index) }
        }
    }
    
    func getMonth(byIndex index: Int) -> String {
        let month = Calendar.current.date(byAdding: .month, value: -(index % 12), to: Date())
        return DateFormatter.monthFormatter.string(from: month!)
    }
    
    func getYear(byIndex index: Int) -> String {
        if displayMode == MONTHLY {
            let year = Calendar.current.date(byAdding: .year, value: -(index / 12), to: Date())
            return DateFormatter.yearFormatter.string(from: year!)
        } else {
            let year = Calendar.current.date(byAdding: .year, value: -index, to: Date())
            return DateFormatter.yearFormatter.string(from: year!)
        }
    }
    
    @IBAction func changedValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            entries = DataService.shared.getExpense()
            setTotalAmount(pagenumber: currentPageNumber)
            collectionView.reloadData()
            amountHeight.constant = 21
            totalAmountHeight.constant = 21
            distanceToAd.constant = 20
            hideAmount()
            totalAmountLabel.isHidden = false
            isBlanceSelected = false
            view.layoutIfNeeded()
            break
        case 1:
            entries = DataService.shared.getIncome()
            setTotalAmount(pagenumber: currentPageNumber)
            collectionView.reloadData()
            amountHeight.constant = 21
            totalAmountHeight.constant = 21
            distanceToAd.constant = 20
            hideAmount()
            totalAmountLabel.isHidden = false
            isBlanceSelected = false
            view.layoutIfNeeded()
            break
        case 2:
            balanceEntries = [[Entry]]()
            balanceEntries.append(DataService.shared.getIncome())
            balanceEntries.append(DataService.shared.getExpense())
            hideAmount()
            isBlanceSelected = true
            totalAmountLabel.isHidden = true
            amountHeight.constant = 0
            totalAmountHeight.constant = 0
            distanceToAd.constant = 0
            view.layoutIfNeeded()
            collectionView.reloadData()
            break
        default:
            break;
        }
    }
    
    @IBAction func rightButtonPushed(_ sender: UIButton) {
        if currentPageNumber > 0 {
            currentPageNumber -= 1
            let indexPath = IndexPath(item: currentPageNumber, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            setLabelsToNewPage()
        }
    }
    
    @IBAction func leftButtonPushed(_ sender: UIButton) {
        if currentPageNumber < 35 {
            currentPageNumber += 1
            let indexPath = IndexPath(item: currentPageNumber, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            setLabelsToNewPage()
        }
    }
    
    func setLabelsToNewPage() {
        if displayMode == MONTHLY {
            dateLabel.text = "\(getMonth(byIndex: currentPageNumber)) \(getYear(byIndex: currentPageNumber))"
        } else {
            dateLabel.text = getYear(byIndex: currentPageNumber)
        }
        setTotalAmount(pagenumber: currentPageNumber)
        amountLabel.isHidden = true
        
        currentPageNumber == 35 ? (leftButton.isHidden = true) : (leftButton.isHidden = false)
        currentPageNumber == 0 ? (rightButton.isHidden = true) : (rightButton.isHidden = false)
    }
    
    @objc func exportData() {
        let fileName = "Budget_Buch_" + dateLabel.text!.trimmingCharacters(in: .whitespaces)
        
        let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("csv")
        
        if fileURL != nil  {
            do {
                
                balanceEntries = [[Entry]]()
                balanceEntries.append(DataService.shared.getIncome())
                balanceEntries.append(DataService.shared.getExpense())
                
                let filteredIncomes = filterEntries(byIndex: currentPageNumber, entries: balanceEntries[0])
                let filteredExpenses = filterEntries(byIndex: currentPageNumber, entries: balanceEntries[1])
                
                let summedIncomes = sumByCategory(entries: filteredIncomes)
                let summedExpenses = sumByCategory(entries: filteredExpenses)
                
                var exportData = CATEGORY + ";" + AMOUNT + "\n"
                
                for income in summedIncomes {
                    exportData += income.category + ";"
                    exportData += NumberFormatter.currencyFormatter.string(from: income.amount as NSNumber)! + "\n"
                }
                
                exportData += ";\n"
                
                for income in summedExpenses {
                    exportData += income.category + ";"
                    exportData += NumberFormatter.currencyFormatter.string(from: income.amount as NSNumber)! + "\n"
                }
                
                try exportData.write(to: fileURL!, atomically: true, encoding: .utf8)
                
            } catch let error as NSError {
                print("Error: \(error)")
            }
        }
        
        let activityViewController = UIActivityViewController(activityItems: [fileURL!], applicationActivities: nil)
        activityViewController.view.tintColor = .appThemeColor
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.completionWithItemsHandler = {
            (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed == true {
                let fileManager = FileManager.default
                do {
                    try fileManager.removeItem(at: fileURL!)
                }
                catch let error as NSError {
                    print("Error: \(error)")
                }
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
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
}
