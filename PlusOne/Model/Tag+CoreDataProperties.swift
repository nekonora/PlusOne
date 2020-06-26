//
//  Tag+CoreDataProperties.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 26/06/2020.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var identifier: UUID?
    @NSManaged public var name: String?
    @NSManaged public var color: String?
    @NSManaged public var counters: NSSet?

}

// MARK: Generated accessors for counters
extension Tag {

    @objc(addCountersObject:)
    @NSManaged public func addToCounters(_ value: Counter)

    @objc(removeCountersObject:)
    @NSManaged public func removeFromCounters(_ value: Counter)

    @objc(addCounters:)
    @NSManaged public func addToCounters(_ values: NSSet)

    @objc(removeCounters:)
    @NSManaged public func removeFromCounters(_ values: NSSet)

}
