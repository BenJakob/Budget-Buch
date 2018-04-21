//
//  IconCell.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 01.11.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class IconCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 5
    }
    
    override var isSelected: Bool {
        didSet {
            self.contentView.layer.borderWidth = isSelected ? 2 : 0
            self.contentView.layer.borderColor = isSelected ? UIColor.appThemeColor.cgColor : UIColor.clear.cgColor
        }
    }
}
