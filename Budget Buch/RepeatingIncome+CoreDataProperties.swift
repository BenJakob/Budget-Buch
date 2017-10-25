//
//  RepeatingIncome+CoreDataProperties.swift
//  Budget Buch
//
//  Created by Benjamin Jakob on 24.10.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//
//

import Foundation
import CoreData


extension RepeatingIncome {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepeatingIncome> {
        return NSFetchRequest<RepeatingIncome>(entityName: "RepeatingIncome")
    }

    @NSManaged public var periode: String?

}
