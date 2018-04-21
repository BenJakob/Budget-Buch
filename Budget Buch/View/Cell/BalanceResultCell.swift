//
//  BalanceResultCell.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 30.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class BalanceResultCell: UITableViewCell {

    var amount: Double? {
        didSet {
            guard let amount = amount else { return }
            amountLabel.textColor = amount < 0 ? .red : .black
            amountLabel.text = NumberFormatter.currencyFormatter.string(from: amount as NSNumber)
        }
    }
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.text = TOTAL
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(resultLabel)
        addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: topAnchor),
            resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            resultLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            amountLabel.topAnchor.constraint(equalTo: topAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            amountLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
