//
//  Counter+CoreDataProperties.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 25/07/20.
//
//

import Foundation
import CoreData

extension Counter {
    
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Counter> {
        NSFetchRequest<Counter>(entityName: "Counter")
    }
    
    @NSManaged public var completionValue: Float
    @NSManaged public var createdAt: Date
    @NSManaged public var currentValue: Float
    @NSManaged public var identifier: UUID
    @NSManaged public var increment: Float
    @NSManaged public var name: String
    @NSManaged public var updatedAt: Date
    @NSManaged public var changes: NSSet?
    @NSManaged public var unit: String?
    @NSManaged public var group: Group?
    @NSManaged public var tags: NSSet?
}

// MARK: Generated accessors for changes
extension Counter {

    @objc(addChangesObject:)
    @NSManaged public func addToChanges(_ value: ChangeRecord)

    @objc(removeChangesObject:)
    @NSManaged public func removeFromChanges(_ value: ChangeRecord)

    @objc(addChanges:)
    @NSManaged public func addToChanges(_ values: NSSet)

    @objc(removeChanges:)
    @NSManaged public func removeFromChanges(_ values: NSSet)

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

extension Counter: Identifiable {

}
