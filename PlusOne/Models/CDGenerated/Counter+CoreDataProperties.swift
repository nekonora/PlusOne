//
//  Counter+CoreDataProperties.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 10/06/22.
//
//

import Foundation
import CoreData


extension Counter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Counter> {
        return NSFetchRequest<Counter>(entityName: "Counter")
    }

    @NSManaged public var completionValue: Double
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var steps: Double
    @NSManaged public var unit: String?
    @NSManaged public var value: Double
    @NSManaged public var modifiedAt: Date?
    @NSManaged public var tags: NSSet?

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

extension Counter : Identifiable {

}
