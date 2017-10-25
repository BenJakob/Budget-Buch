//
//  StandardCell.swift
//  Haushaltsbuch
//
//  Created by Benjamin Jakob on 02.08.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//

import UIKit

class StandardCell: UITableViewCell, UITextFieldDelegate {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        textField.delegate = self
    }
    
    let nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.clearButtonMode = .whileEditing
        return field
    }()
    
    func setupViews() {
        backgroundColor = .white
        addSubview(nameLabel)
        addSubview(textField)
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                nameLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                nameLabel.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.35),
                
                textField.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
                textField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16),
                textField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                ])
        } else {
            NSLayoutConstraint.activate([
                nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35),
                
                textField.centerYAnchor.constraint(equalTo: centerYAnchor),
                textField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 16),
                textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                ])
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 12
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)@objc  has not been implemented")
    }
}
