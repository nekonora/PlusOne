//
//  Group+CoreDataProperties.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 27/06/2020.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var identifier: UUID
    @NSManaged public var name: String
    @NSManaged public var counters: NSSet

}

// MARK: Generated accessors for counters
extension Group {

    @objc(addCountersObject:)
    @NSManaged public func addToCounters(_ value: Counter)

    @objc(removeCountersObject:)
    @NSManaged public func removeFromCounters(_ value: Counter)

    @objc(addCounters:)
    @NSManaged public func addToCounters(_ values: NSSet)

    @objc(removeCounters:)
    @NSManaged public func removeFromCounters(_ values: NSSet)

}
