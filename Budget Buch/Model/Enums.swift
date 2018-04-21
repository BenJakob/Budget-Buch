//
//  Enums.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 30.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import Foundation

enum Direction {
    case up, down
}

enum EntryClass {
    case income, expense, repeatingExpense, repeatingIncome
}

enum CategoryClass {
    case income, expense, otherExpense, otherIncome
}

enum DisplayMode {
    case month, year
}

enum ControllerMode {
    case addIncome, addExpense
    case editIncome, editExpense
    case addRepeatingIncome, addRepeatingExpense
    case editRepeatingIncome, editRepeatingExpense
}

enum SelectViewMode {
    case interval, category
    case startDate, endDate
}

