//
//  ChangeRecord+CoreDataProperties.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 25/07/20.
//
//

import Foundation
import CoreData


extension ChangeRecord {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<ChangeRecord> {
        NSFetchRequest<ChangeRecord>(entityName: "ChangeRecord")
    }

    @NSManaged public var key: String
    @NSManaged public var date: Date
    @NSManaged public var newValue: Float
    @NSManaged public var oldValue: Float
    @NSManaged public var counter: Counter
}

extension ChangeRecord: Identifiable {

}
