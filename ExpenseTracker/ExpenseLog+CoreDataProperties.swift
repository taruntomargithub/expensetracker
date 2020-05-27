//
//  ExpenseLog+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Tarun Tomar on 06/05/20.
//  Copyright © 2020 Tarun Tomar. All rights reserved.
//
//

import Foundation
import CoreData


extension ExpenseLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseLog> {
        return NSFetchRequest<ExpenseLog>(entityName: "ExpenseLog")
    }

    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var amount: Double

}
