//
//  ColorCell.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 01.11.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var checkMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.colorView.layer.cornerRadius = 5
        self.contentView.layer.cornerRadius = 5
    }
    
    override var isSelected: Bool {
        didSet {
            isSelected ? (checkMark.isHidden = false) : (checkMark.isHidden = true)
        }
    }
}
