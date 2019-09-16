//
//  Tag+CoreDataProperties.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 16/09/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var title: String?
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
