//
//  ExpenseEntry+CoreDataProperties.swift
//  Haushaltsbuch
//
//  Created by Benjamin Jakob on 21.10.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//
//

import Foundation
import CoreData


extension ExpenseEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseEntry> {
        return NSFetchRequest<ExpenseEntry>(entityName: "ExpenseEntry")
    }


}
