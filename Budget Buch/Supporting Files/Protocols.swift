//
//  Protocols.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 10.11.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import Foundation

protocol NewEntryDelegate {
    func updateConstraints()
}

protocol RepeatingDelegate {
    func insert(entry: RepeatingEntry)
    func delete()
    func update()
}

protocol CategoryDelegate {
    func deselectRow()
    func insertNewCategory(_ category: Category)
    func deleteCategory()
    func updateTable()
}

protocol CategoryDetailDelegate {
    func configure(category: Category?)
}

protocol SettingsDelegate {
    func deselectRow()
}

protocol StatisticsVCDelegate {
    func setAmount(category: String, amount: Double)
    func hideAmount()
}
