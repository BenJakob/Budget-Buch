//
//  DataService.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 25.10.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//

import Foundation
import CoreData

class DataService {

    // MARK: - Attributes 
    static let instance = DataService()
    private var headerTitles: [String]!
    private var sortedEntries: [[Entry]]!
    
    // MARK: - Functions
    private init() { }
    
    func getIncomeEntries() -> [[Entry]] {
        do {
            let entriesFetchRequest: NSFetchRequest<IncomeEntry>?
            entriesFetchRequest = IncomeEntry.fetchRequest()
            let incomes = try DatabaseController.getContext().fetch(entriesFetchRequest!)
            return sortByDate(entries: incomes)
        } catch let error as NSError {
            print("Error loading Entries: \(error) ")
        }
        return [[Entry]]()
    }
    
    func getExpenseEntries() -> [[Entry]] {
        do {
            let entriesFetchRequest: NSFetchRequest<ExpenseEntry>?
            entriesFetchRequest = ExpenseEntry.fetchRequest()
            let expenses = try DatabaseController.getContext().fetch(entriesFetchRequest!)
            return sortByDate(entries: expenses)
            
        } catch let error as NSError {
            print("Error loading Entries: \(error) ")
        }
        return [[Entry]]()
    }
    
    func getHeaderData() -> [String] {
        return headerTitles
    }
    
    func deleteEntry(indexPath: IndexPath) {
        DatabaseController.getContext().delete(sortedEntries[indexPath.section - 1][indexPath.row])
        DatabaseController.saveContext()
    }
    
    private func sortByDate(entries: [Entry]) -> [[Entry]]{
        headerTitles = [String]()
        sortedEntries = [[Entry]]()
        headerTitles.append("")
        
        var yearIndex = 0
        var monthIndex = 0
        var countFilteredEntriesByYear = 0
        
        while entries.count > countFilteredEntriesByYear {
            
            var countFilteredEntriesByMonth = 0
            let date = Calendar.current.date(byAdding: .year, value: -yearIndex, to: Date())
            let currentYear = DateFormatter.yearFormatter.string(from: date!)
            
            let filteredByYear = entries.filter { DateFormatter.yearFormatter.string(from: (($0 as Entry).date! as Date)) == currentYear }
            countFilteredEntriesByYear += filteredByYear.count
            
            while filteredByYear.count > countFilteredEntriesByMonth {
                let date = Calendar.current.date(byAdding: .month, value: -monthIndex, to: Date())
                let currentMonth = DateFormatter.monthFormatter.string(from: date!)
                let filteredByMonth = filteredByYear.filter { DateFormatter.monthFormatter.string(from: (($0 as Entry).date! as Date)) == currentMonth }
                if filteredByMonth.count > 0 {
                    headerTitles.append(currentMonth + " " + currentYear)
                    sortedEntries!.append(filteredByMonth)
                }
                countFilteredEntriesByMonth += filteredByMonth.count
                monthIndex += 1
            }
            yearIndex += 1
        }
        return sortedEntries
    }
}
