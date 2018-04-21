//
//  EntryDelegateVC.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 13.11.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import UIKit

protocol EntryDelegate {
    func configureAsNewExpenseVC()
    func configureAsNewIncomeVC()
    func configureAsEditExpenseVC(expense: Expense)
    func configureAsEditIncomeVC(income: Income)
    func configureAsNewRepeatingExpenseVC(delegate: RepeatingDelegate)
    func configureAsNewRepeatingIncomeVC(delegate: RepeatingDelegate)
    func configureAsEditRepeatingExpenseVC(expense: RepeatingExpense, delegate: RepeatingDelegate)
    func configureAsEditRepeatingIncomeVC(income: RepeatingIncome, delegate: RepeatingDelegate)
}

class EntryDelegateVC: UINavigationController, EntryDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureAsNewExpenseVC() {
        let rootViewController = self.viewControllers.first
        (rootViewController as! AddVCDelegate).configureAsNewExpenseVC()
    }
    
    func configureAsNewIncomeVC() {
        let rootViewController = self.viewControllers.first
        (rootViewController as! AddVCDelegate).configureAsNewIncomeVC()
    }
    
    func configureAsEditExpenseVC(expense: Expense) {
        let rootViewController = self.viewControllers.first
        _ = rootViewController?.view
        (rootViewController as! AddVCDelegate).configureAsEditExpenseVC(expense: expense)
    }
    
    func configureAsEditIncomeVC(income: Income) {
        let rootViewController = self.viewControllers.first
        _ = rootViewController?.view
        (rootViewController as! AddVCDelegate).configureAsEditIncomeVC(income: income)
    }
    
    func configureAsNewRepeatingExpenseVC(delegate: RepeatingDelegate) {
        let rootViewController = self.viewControllers.first
        (rootViewController as! AddVCDelegate).configureAsNewRepeatingExpenseVC(delegate: delegate)
    }
    
    func configureAsNewRepeatingIncomeVC(delegate: RepeatingDelegate) {
        let rootViewController = self.viewControllers.first
        (rootViewController as! AddVCDelegate).configureAsNewRepeatingIncomeVC(delegate: delegate)
    }
    
    func configureAsEditRepeatingExpenseVC(expense: RepeatingExpense, delegate: RepeatingDelegate) {
        let rootViewController = self.viewControllers.first
        _ = rootViewController?.view
        (rootViewController as! AddVCDelegate).configureAsEditRepeatingExpenseVC(expense: expense, delegate: delegate)
    }
    
    func configureAsEditRepeatingIncomeVC(income: RepeatingIncome, delegate: RepeatingDelegate) {
        let rootViewController = self.viewControllers.first
        _ = rootViewController?.view
        (rootViewController as! AddVCDelegate).configureAsEditRepeatingIncomeVC(income: income, delegate: delegate)
    }
    
}
