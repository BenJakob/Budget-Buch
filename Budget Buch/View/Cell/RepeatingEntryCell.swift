//
//  RepeatingEntryCell.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 09.11.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class RepeatingEntryCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureCell(entry: RepeatingEntry) {
        let index = Int(entry.category!.iconIndex)
        icon.image = UIImage(named: icons[index])
        categoryLabel.text = entry.category!.name!
        startDateLabel.text = START + ": " + (DateFormatter.customFormatter.string(from: entry.date! as Date))
        amountLabel.text = NumberFormatter.currencyFormatter.string(from: entry.amount as NSNumber)
        guard let endDate = entry.endDate else {
            endDateLabel.text = END_NOT_SET
            return
        }
        endDateLabel.text = END + ": " + (DateFormatter.customFormatter.string(from: endDate as Date))
    }
}
