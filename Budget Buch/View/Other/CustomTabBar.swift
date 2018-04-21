//
//  CustomTabBar.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 29.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBar {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.items?[0].title = EXPENSES_TITLE
        self.items?[1].title = INCOME_TITLE
        self.items?[2].title = STATISTICS_TITLE
    }
}
