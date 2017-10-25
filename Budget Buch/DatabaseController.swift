//
//  DatabaseController.swift
//  Haushaltsbuch
//
//  Created by Benjamin Jakob on 21.10.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//

import Foundation
import CoreData

enum EntryClass {
    case incomeEntry, expenseEntry, repeatingExpense, repeatingIncome
}

class DatabaseController {
    
    private init() { }
    
    class func getContext() -> NSManagedObjectContext {
        return DatabaseController.persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Haushaltsbuch")
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
    
    class func insertEntry(forEntityName entityName: String, as entryClass: EntryClass, category: String, date: String, amount: String, periode: String) {
        
        guard let formattedDate = DateFormatter.customFormatter.date(from: date) as NSDate? else { return }
        guard let formattedAmount = NumberFormatter.decimalFormatter.number(from: amount) else { return }
        
        switch entryClass {
        case .incomeEntry:
            let newEntry = NSEntityDescription.insertNewObject(forEntityName: entityName, into: getContext()) as! IncomeEntry
            newEntry.category = category
            newEntry.date = formattedDate
            newEntry.amount = Double(truncating: formattedAmount)
            break
        case .expenseEntry:
            let newEntry = NSEntityDescription.insertNewObject(forEntityName: entityName, into: getContext()) as! ExpenseEntry
            newEntry.category = category
            newEntry.date = formattedDate
            newEntry.amount = Double(truncating: formattedAmount)
            break
        case .repeatingIncome:
            let newEntry = NSEntityDescription.insertNewObject(forEntityName: entityName, into: getContext()) as! RepeatingIncome
            newEntry.category = category
            newEntry.date = formattedDate
            newEntry.amount = Double(truncating: formattedAmount)
            newEntry.periode = periode
            break
        case .repeatingExpense:
            let newEntry = NSEntityDescription.insertNewObject(forEntityName: entityName, into: getContext()) as! RepeatingExpense
            newEntry.category = category
            newEntry.date = formattedDate
            newEntry.amount = Double(truncating: formattedAmount)
            newEntry.periode = periode
            break
        }
        saveContext()
    }
}
