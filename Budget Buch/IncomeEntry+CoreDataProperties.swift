//
//  IncomeEntry+CoreDataProperties.swift
//  Haushaltsbuch
//
//  Created by Benjamin Jakob on 21.10.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//
//

import Foundation
import CoreData


extension IncomeEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IncomeEntry> {
        return NSFetchRequest<IncomeEntry>(entityName: "IncomeEntry")
    }


}
