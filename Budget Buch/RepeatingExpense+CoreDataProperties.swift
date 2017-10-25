//
//  RepeatingExpense+CoreDataProperties.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 24.10.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//
//

import Foundation
import CoreData


extension RepeatingExpense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepeatingExpense> {
        return NSFetchRequest<RepeatingExpense>(entityName: "RepeatingExpense")
    }

    @NSManaged public var periode: String?

}
