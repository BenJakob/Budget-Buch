//
//  BalanceDetailCell.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 30.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class BalanceDetailCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureIncomeCell(entry: BalanceCellData) {
        icon.image = UIImage(named: entry.imageName)
        categoryLabel.text = entry.category
        amountLabel.textColor = .black
        amountLabel.text = NumberFormatter.currencyFormatter.string(from: entry.amount as NSNumber)
    }
    
    func configureExpenseCell(entry: BalanceCellData) {
        icon.image = UIImage(named: entry.imageName)
        categoryLabel.text = entry.category
        amountLabel.textColor = .red
        amountLabel.text = NumberFormatter.currencyFormatter.string(from: entry.amount as NSNumber)
    }
    
}
