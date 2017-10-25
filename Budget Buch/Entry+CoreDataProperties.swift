//
//  Entry+CoreDataProperties.swift
//  Haushaltsbuch
//
//  Created by Benjamin Jakob on 21.10.17.
//  Copyright © 2017 Benjamin Jakob. All rights reserved.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var category: String?
    @NSManaged public var amount: Double

}
