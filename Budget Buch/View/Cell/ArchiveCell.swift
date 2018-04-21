//
//  ArchiveCell.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 27.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class ArchiveCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(entry: Entry) {
        let index = Int(entry.category!.iconIndex)
        icon.image = UIImage(named: icons[index])
        categoryLabel.text = entry.category!.name!
        dateLabel.text = DateFormatter.customFormatter.string(from: entry.date! as Date)
        amountLabel.text = NumberFormatter.currencyFormatter.string(from: entry.amount as NSNumber)
    }

}

class NoDataCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = NO_DATA_FOUND
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
}
