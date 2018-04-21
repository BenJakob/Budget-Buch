//
//  CategoryCell.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 01.11.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(data: Category) {
        name.text = data.name!
        icon.image = UIImage(named: icons[Int(data.iconIndex)])
    }
}
