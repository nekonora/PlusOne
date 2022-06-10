//
//  Counter.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 02/06/22.
//
//

import Foundation
import CoreData

enum CounterOperation {
    case increase, decrease
}

struct CounterData: Identifiable, Hashable {
    let id: UUID
    let createdAt: Date
    var modifiedAt: Date
    var name: String
    var value: Double
    var steps: Double?
    var unit: String?
    var completionValue: Double?
}

extension CounterData {
    
    func getCDObject(for context: NSManagedObjectContext) -> Counter {
        let counter = Counter(context: context)
        counter.createdAt = self.createdAt
        counter.id = self.id
        counter.modifiedAt = self.modifiedAt
        counter.value = self.value
        counter.name = self.name
        counter.steps = self.steps ?? 1
        counter.unit = self.unit
        counter.completionValue = self.completionValue ?? 0
        return counter
    }
}

extension Counter: ThreadSafeable {
    
    func getSafeObject() -> CounterData? {
        guard let id = id,
              let createdAt = createdAt,
              let modifiedAt = modifiedAt,
              let name = name
        else {
            return nil
        }
        return CounterData(
            id: id,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            name: name,
            value: value,
            steps: steps.nilIfZero ?? 1,
            unit: unit?.nilIfEmpty,
            completionValue: completionValue.nilIfZero
        )
    }
}
