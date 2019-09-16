//
//  Counter+CoreDataProperties.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 16/09/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//
//

import Foundation
import CoreData


extension Counter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Counter> {
        return NSFetchRequest<Counter>(entityName: "Counter")
    }

    @NSManaged public var completionValue: Double
    @NSManaged public var currentValue: Double
    @NSManaged public var id: UUID?
    @NSManaged public var increment: Double
    @NSManaged public var name: String?
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
