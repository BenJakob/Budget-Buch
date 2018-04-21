//
//  DataService.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 25.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import Foundation
import CoreData

class DataService {
    
    // MARK: - Attributes
    static let shared = DataService()
    private var sectionTitles: [String]?
    private var sortedEntries: [[Entry]]?
    
    // MARK: - Functions
    private init() { }
    
    func getIncome() -> [Income] {
        do {
            let entriesFetchRequest: NSFetchRequest<Income>?
            entriesFetchRequest = Income.fetchRequest()
            return try DatabaseController.getContext().fetch(entriesFetchRequest!)
        } catch let error as NSError {
            print("Error loading Entries: \(error) ")
        }
        return [Income]()
    }
    
    func getExpense() -> [Expense] {
        do {
            let entriesFetchRequest: NSFetchRequest<Expense>?
            entriesFetchRequest = Expense.fetchRequest()
            return try DatabaseController.getContext().fetch(entriesFetchRequest!)            
        } catch let error as NSError {
            print("Error loading Entries: \(error) ")
        }
        return [Expense]()
    }
    
    func getHeaderData() -> [String] {
        if let titles = sectionTitles {
            return titles
        } else {
            return [String]()
        }
    }
    
    func deleteEntry(indexPath: IndexPath) {
        if let entries = sortedEntries {
            DatabaseController.getContext().delete(entries[indexPath.section][indexPath.row])
            DatabaseController.saveContext()
        }
    }
    
    func getSortedEntries(entries: [Entry]) -> [[Entry]]{
        sectionTitles = [String]()
        sortedEntries = [[Entry]]()
        
        var yearIndex = 0
        var monthIndex = 0
        var countFilteredEntriesByYear = 0
        
        while entries.count > countFilteredEntriesByYear {
            
            var countFilteredEntriesByMonth = 0
            let date = Calendar.current.date(byAdding: .year, value: -yearIndex, to: Date())
            let currentYear = DateFormatter.yearFormatter.string(from: date!)
            
            let filteredByYear = entries.filter { DateFormatter.yearFormatter.string(from: (($0 as Entry).date! as Date as Date)) == currentYear }
            countFilteredEntriesByYear += filteredByYear.count
            
            while filteredByYear.count > countFilteredEntriesByMonth {
                let date = Calendar.current.date(byAdding: .month, value: -monthIndex, to: Date())
                let currentMonth = DateFormatter.monthFormatter.string(from: date!)
                var filteredByMonth = filteredByYear.filter { DateFormatter.monthFormatter.string(from: (($0 as Entry).date! as Date)) == currentMonth }
                if filteredByMonth.count > 0 {
                    filteredByMonth = filteredByMonth.sorted(by: { $0.date!.compare($1.date!) == .orderedDescending })
                    sectionTitles!.append(currentMonth + " " + currentYear)
                    sortedEntries!.append(filteredByMonth)
                }
                countFilteredEntriesByMonth += filteredByMonth.count
                monthIndex += 1
            }
            yearIndex += 1
        }
        return sortedEntries!
    }
    
    func getIncomesCategories() -> [Category] {
        do {
            let categoryFetchRequest: NSFetchRequest<IncomeCategory>?
            categoryFetchRequest = IncomeCategory.fetchRequest()
            return try DatabaseController.getContext().fetch(categoryFetchRequest!)
        } catch let error as NSError {
            print("Error loading Entries: \(error) ")
        }
        return [Category]()
    }
    
    func getExpensesCategories() -> [Category] {
        do {
            let categoryFetchRequest: NSFetchRequest<ExpenseCategory>?
            categoryFetchRequest = ExpenseCategory.fetchRequest()
            return try DatabaseController.getContext().fetch(categoryFetchRequest!)
        } catch let error as NSError {
            print("Error loading Entries: \(error) ")
        }
        return [Category]()
    }
    
    func getCategory(byName name: String) -> [Category] {
        do {
            let categoryFetchRequest: NSFetchRequest<Category>?
            categoryFetchRequest = Category.fetchRequest()
            categoryFetchRequest?.predicate = NSPredicate(format: "name == %@", name)
            return try DatabaseController.getContext().fetch(categoryFetchRequest!)
        } catch let error as NSError {
            print("Error loading Entries: \(error) ")
        }
        return [Category]()
    }
    
    func getOtherExpenseCategory() -> [Category] {
        do {
            let categoryFetchRequest: NSFetchRequest<OtherExpense>?
            categoryFetchRequest = OtherExpense.fetchRequest()
            return try DatabaseController.getContext().fetch(categoryFetchRequest!)
        } catch let error as NSError {
            print("Error loading Entries: \(error) ")
        }
        return [Category]()
    }
    
    func getOtherIncomeCategory() -> [Category] {
        do {
            let categoryFetchRequest: NSFetchRequest<OtherIncome>?
            categoryFetchRequest = OtherIncome.fetchRequest()
            return try DatabaseController.getContext().fetch(categoryFetchRequest!)
        } catch let error as NSError {
            print("Error loading Entries: \(error) ")
        }
        return [Category]()
    }
    
    func getRepeatingIncome() -> [RepeatingIncome] {
        do {
            let categoryFetchRequest: NSFetchRequest<RepeatingIncome>?
            categoryFetchRequest = RepeatingIncome.fetchRequest()
            return try DatabaseController.getContext().fetch(categoryFetchRequest!)
        } catch let error as NSError {
            print("Error loading Entries: \(error) ")
        }
        return [RepeatingIncome]()
    }
    
    func getRepeatingExpense() -> [RepeatingExpense] {
        do {
            let categoryFetchRequest: NSFetchRequest<RepeatingExpense>?
            categoryFetchRequest = RepeatingExpense.fetchRequest()
            return try DatabaseController.getContext().fetch(categoryFetchRequest!)
        } catch let error as NSError {
            print("Error loading Entries: \(error) ")
        }
        return [RepeatingExpense]()
    }
    
    func delete(category: Category) {
        DatabaseController.getContext().delete(category)
        DatabaseController.saveContext()
    }
    
    func delete(income: Income) {
        DatabaseController.getContext().delete(income)
        DatabaseController.saveContext()
    }
    
    func delete(income: RepeatingIncome) {
        DatabaseController.getContext().delete(income)
        DatabaseController.saveContext()
    }
    
    func delete(expense: Expense) {
        DatabaseController.getContext().delete(expense)
        DatabaseController.saveContext()
    }
    
    func delete(expense: RepeatingExpense) {
        DatabaseController.getContext().delete(expense)
        DatabaseController.saveContext()
    }
}

