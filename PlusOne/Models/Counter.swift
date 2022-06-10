//
//  Counter.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 02/06/22.
//
//

import Foundation
import CoreData

struct CounterData: Identifiable, Hashable {
    let id: UUID
    let createdAt: Date
    let name: String
    let value: Double
    let steps: Double?
    let unit: String?
    let completionValue: Double?
}

@objc(Counter)
public class Counter: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Counter> {
        NSFetchRequest<Counter>(entityName: "Counter")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var value: Double
    @NSManaged public var steps: Double
    @NSManaged public var unit: String?
    @NSManaged public var completionValue: Double
}

extension Counter: Identifiable { }

extension Counter: ThreadSafeable {
    
    func getSafeObject() -> CounterData? {
        guard let id = id, let createdAt = createdAt, let name = name
        else {
            return nil
        }
        return CounterData(
            id: id,
            createdAt: createdAt,
            name: name,
            value: value,
            steps: steps.nilIfZero,
            unit: unit?.nilIfEmpty,
            completionValue: completionValue.nilIfZero
        )
    }
}
