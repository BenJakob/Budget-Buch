//
//  ArchiveCell.swift
//  Haushaltsbuch
//
//  Created by Benjamin Jakob on 21.10.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//

import UIKit

class ArchiveCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func updateData(cellData: Entry) {
        nameLabel.text = cellData.category
        dateLabel.text = DateFormatter.customFormatter.string(from: cellData.date! as Date)
        amountLabel.text = NumberFormatter.currencyFormatter.string(from: cellData.amount as NSNumber)
        iconImage.image = UIImage(named: cellData.category!)
    }
    
    func setupViews() {
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        addSubview(stackView)
        addSubview(amountLabel)
        addSubview(iconImage)
        
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                iconImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
                iconImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
                iconImage.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,constant: -4),
                
                stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
                stackView.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 16),
                stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,constant: -4),
                
                amountLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
                amountLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
                ])
        } else {
            NSLayoutConstraint.activate([
                iconImage.topAnchor.constraint(equalTo: topAnchor, constant: 4),
                iconImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                iconImage.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -4),
                
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
                stackView.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 16),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -4),
                
                amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
                ])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        label.text = "Keine Archivdaten vorhanden"
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
