//
//  Counter+CoreDataProperties.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 26/06/2020.
//
//

import Foundation
import CoreData


extension Counter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Counter> {
        return NSFetchRequest<Counter>(entityName: "Counter")
    }

    @NSManaged public var identifier: UUID?
    @NSManaged public var name: String?
    @NSManaged public var currentValue: Float
    @NSManaged public var increment: Float
    @NSManaged public var completionValue: Float
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var tags: NSSet?
    @NSManaged public var group: Group?

}

// MARK: Generated accessors for tags
extension Counter {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
