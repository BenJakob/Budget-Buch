//
//  DatabaseController.swift
//  Haushaltsbuch
//
//  Created by Benjamin Jakob on 21.10.17.
//  Copyright © 2017 Fenox. All rights reserved.
//

import Foundation
import CoreData

class DatabaseController {

    class func getContext() -> NSManagedObjectContext {
        return DatabaseController.persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: CONTAINER_NAME)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    class func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    class func insertEntry(forEntityName entityName: String, as entryClass: EntryClass, category: Category, date: String, amount: String, interval: String) {
        
        guard let formattedDate = DateFormatter.customFormatter.date(from: date) as NSDate? else { return }
        guard let formattedAmount = NumberFormatter.decimalFormatter.number(from: amount) else { return }
        
        switch entryClass {
        case .income:
            let newEntry = NSEntityDescription.insertNewObject(forEntityName: entityName, into: getContext()) as! Income
            newEntry.category = category
            newEntry.date = formattedDate as Date
            newEntry.amount = Double(truncating: formattedAmount)
            newEntry.isRepeating = false
            break
        case .expense:
            let newEntry = NSEntityDescription.insertNewObject(forEntityName: entityName, into: getContext()) as! Expense
            newEntry.category = category
            newEntry.date = formattedDate as Date
            newEntry.amount = Double(truncating: formattedAmount)
            newEntry.isRepeating = false
            break
        case .repeatingIncome:
            let newEntry = NSEntityDescription.insertNewObject(forEntityName: entityName, into: getContext()) as! RepeatingIncome
            newEntry.category = category
            newEntry.date = formattedDate as Date
            newEntry.amount = Double(truncating: formattedAmount)
            newEntry.interval = interval
            break
        case .repeatingExpense:
            let newEntry = NSEntityDescription.insertNewObject(forEntityName: entityName, into: getContext()) as! RepeatingExpense
            newEntry.category = category
            newEntry.date = formattedDate as Date
            newEntry.amount = Double(truncating: formattedAmount)
            newEntry.interval = interval
            break
        }
        saveContext()
    }
    
    class func insertExpense(category: Category, date: Date, amount: Double, isRepeating: Bool, notes: String) {
        let newEntry = NSEntityDescription.insertNewObject(forEntityName: EXPENSE, into: getContext()) as! Expense
        newEntry.category = category
        newEntry.date = date
        newEntry.amount = amount
        newEntry.isRepeating = isRepeating

        saveContext()
    }
    
    class func insertExpense(category: String, date: String, amount: String, isRepeating: Bool, notes: String) {
        guard let formattedDate = DateFormatter.customFormatter.date(from: date) else { return }
        guard let formattedAmount = NumberFormatter.decimalFormatter.number(from: amount) else { return }
        
        let categories = DataService.shared.getCategory(byName: category)
        if categories.count <= 0 { return }
        
        let newEntry = NSEntityDescription.insertNewObject(forEntityName: EXPENSE, into: getContext()) as! Expense
        newEntry.category = categories[0]
        newEntry.date = formattedDate
        newEntry.amount = Double(truncating: formattedAmount)
        newEntry.isRepeating = isRepeating
        newEntry.notes = notes

        saveContext()
    }
    
    class func insertIncome(category: Category, date: Date, amount: Double, isRepeating: Bool, notes: String) {
        let newEntry = NSEntityDescription.insertNewObject(forEntityName: INCOME, into: getContext()) as! Income
        newEntry.category = category
        newEntry.date = date
        newEntry.amount = amount
        newEntry.isRepeating = isRepeating
        newEntry.notes = notes
        
        saveContext()
    }
    
    class func insertIncome(category: String, date: String, amount: String, isRepeating: Bool, notes: String) {
        guard let formattedDate = DateFormatter.customFormatter.date(from: date) else { return }
        guard let formattedAmount = NumberFormatter.decimalFormatter.number(from: amount) else { return }
        
        let categories = DataService.shared.getCategory(byName: category)
        if categories.count <= 0 { return }
        
        let newEntry = NSEntityDescription.insertNewObject(forEntityName: INCOME, into: getContext()) as! Income
        newEntry.category = categories[0]
        newEntry.date = formattedDate
        newEntry.amount = Double(truncating: formattedAmount)
        newEntry.isRepeating = isRepeating
        newEntry.notes = notes
        
        saveContext()
    }
    
    class func insertCategory(name: String, as categoryClass: CategoryClass, colorIndex: Int, iconIndex: Int) {
        
        switch categoryClass {
        case .income:
            let newCategory = NSEntityDescription.insertNewObject(forEntityName: "IncomeCategory", into: getContext()) as! IncomeCategory
            newCategory.name = name
            newCategory.iconIndex = Int32(iconIndex)
            newCategory.colorIndex = Int32(colorIndex)
            break
        case .expense:
            let newCategory = NSEntityDescription.insertNewObject(forEntityName: "ExpenseCategory", into: getContext()) as! ExpenseCategory
            newCategory.name = name
            newCategory.iconIndex = Int32(iconIndex)
            newCategory.colorIndex = Int32(colorIndex)
            break
        case .otherIncome:
            let newCategory = NSEntityDescription.insertNewObject(forEntityName: "OtherIncome", into: getContext()) as! OtherIncome
            newCategory.name = name
            newCategory.iconIndex = Int32(iconIndex)
            newCategory.colorIndex = Int32(colorIndex)
            break
        case .otherExpense:
            let newCategory = NSEntityDescription.insertNewObject(forEntityName: "OtherExpense", into: getContext()) as! OtherExpense
            newCategory.name = name
            newCategory.iconIndex = Int32(iconIndex)
            newCategory.colorIndex = Int32(colorIndex)
            break
        }
        saveContext()
    }
    
    class func insertRepeatingIncome(category: String, startDate: String, endDate: String?, amount: String, interval: String, notes: String?) -> RepeatingIncome? {
        
        guard let formattedStartDate = DateFormatter.customFormatter.date(from: startDate) as NSDate? else { return nil }
        guard let formattedAmount = NumberFormatter.decimalFormatter.number(from: amount) else { return nil }

        let categories = DataService.shared.getCategory(byName: category)
        if categories.count <= 0 { return nil }
        
        let newEntry = NSEntityDescription.insertNewObject(forEntityName: REPEATING_INCOME, into: getContext()) as! RepeatingIncome
        newEntry.category = categories[0]
        newEntry.date = formattedStartDate as Date
        newEntry.amount = Double(truncating: formattedAmount)
        newEntry.interval = interval
        
        if let optionalEndDate = endDate, let optionalNotes = notes {
            if let formattedEndDate = DateFormatter.customFormatter.date(from: optionalEndDate) as NSDate? {
                newEntry.endDate = formattedEndDate as Date
            }
            newEntry.notes = optionalNotes
        }
        saveContext()
        return newEntry
    }
    
    class func insertRepeatingExpense(category: String, startDate: String, endDate: String?, amount: String, interval: String, notes: String?) -> RepeatingExpense? {
        guard let formattedStartDate = DateFormatter.customFormatter.date(from: startDate) as NSDate? else { return nil }
        guard let formattedAmount = NumberFormatter.decimalFormatter.number(from: amount) else { return nil }
        
        let categories = DataService.shared.getCategory(byName: category)
        if categories.count <= 0 { return nil }
        
        let newEntry = NSEntityDescription.insertNewObject(forEntityName: REPEATING_EXPENSE, into: getContext()) as! RepeatingExpense
        newEntry.category = categories[0]
        newEntry.date = formattedStartDate as Date
        newEntry.amount = Double(truncating: formattedAmount)
        newEntry.interval = interval
        
        if let optionalEndDate = endDate, let optionalNotes = notes {
            if let formattedEndDate = DateFormatter.customFormatter.date(from: optionalEndDate) as NSDate? {
                newEntry.endDate = formattedEndDate as Date
            }
            newEntry.notes = optionalNotes
        }
        saveContext()
        return newEntry
    }
    
    class func insertMissingRepeatingIncomes (_ repeatingIncomes: [RepeatingIncome], beginAt startDate: Date) {
        let incomes = DataService.shared.getIncome()
        let calendar = Calendar.current
        let currentDate = Date()
        
        for repeatingIncome in repeatingIncomes {
            
            var dateComponent = DateComponents()
            
            switch repeatingIncome.interval! {
            case WEEKLY:
                dateComponent.day = 7
                break
            case MONTHLY:
                dateComponent.month = 1
                break
            case YEARLY:
                dateComponent.year = 1
                break
            default:
                return
            }
            
            var tempDate = repeatingIncome.date!
            
            while tempDate < startDate {
                tempDate = calendar.date(byAdding: dateComponent, to: tempDate)!
            }
            
            if let endDate = repeatingIncome.endDate {
                while tempDate <= currentDate && tempDate <= endDate {
                    let filteredIncome = incomes.filter({ $0.category! == repeatingIncome.category! && $0.isRepeating && calendar.isDate($0.date!, inSameDayAs: tempDate) })
                    if filteredIncome.count == 0 {
                        insertIncome(category: repeatingIncome.category!, date: tempDate, amount: repeatingIncome.amount, isRepeating: true, notes: repeatingIncome.notes!)
                    }
                    tempDate = calendar.date(byAdding: dateComponent, to: tempDate)!
                }
            } else {
                while tempDate <= currentDate {
                    let filteredIncome = incomes.filter({ $0.category! == repeatingIncome.category! && $0.isRepeating && calendar.isDate($0.date!, inSameDayAs: tempDate) })
                    if filteredIncome.count == 0 {
                        insertIncome(category: repeatingIncome.category!, date: tempDate, amount: repeatingIncome.amount, isRepeating: true, notes: repeatingIncome.notes!)
                    }
                    tempDate = calendar.date(byAdding: dateComponent, to: tempDate)!
                }
            }
        }
    }
    
    class func insertMissingRepeatingExpenses(_ repeatingExpenses: [RepeatingExpense], beginAt startDate: Date) {
        let expenses = DataService.shared.getExpense()
        let calendar = Calendar.current
        let currentDate = Date()
        
        for repeatingExpense in repeatingExpenses {
            
            var dateComponent = DateComponents()
            
            switch repeatingExpense.interval! {
            case WEEKLY:
                dateComponent.day = 7
                break
            case MONTHLY:
                dateComponent.month = 1
                break
            case YEARLY:
                dateComponent.year = 1
                break
            default:
                return
            }
            
            var tempDate = repeatingExpense.date!
            
            while tempDate < startDate {
                tempDate = calendar.date(byAdding: dateComponent, to: tempDate)!
            }
            
            if let endDate = repeatingExpense.endDate {
                while tempDate <= currentDate && tempDate <= endDate {
                    let filteredExpenses = expenses.filter({ $0.category! == repeatingExpense.category! && $0.isRepeating && calendar.isDate($0.date!, inSameDayAs: tempDate) })
                    if filteredExpenses.count == 0 {
                        insertExpense(category: repeatingExpense.category!, date: tempDate, amount: repeatingExpense.amount, isRepeating: true, notes: repeatingExpense.notes!)
                    }
                    tempDate = calendar.date(byAdding: dateComponent, to: tempDate)!
                }
            } else {
                while tempDate <= currentDate {
                    let filteredExpenses = expenses.filter({ $0.category! == repeatingExpense.category! && $0.isRepeating && calendar.isDate($0.date!, inSameDayAs: tempDate) })
                    if filteredExpenses.count == 0 {
                        insertExpense(category: repeatingExpense.category!, date: tempDate, amount: repeatingExpense.amount, isRepeating: true, notes: repeatingExpense.notes!)
                    }
                    tempDate = calendar.date(byAdding: dateComponent, to: tempDate)!
                }
            }
        }
    }
}

