//
//  NSManagedObjectContext+Async.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 02/06/22.
//

import CoreData
import Foundation

extension NSManagedObjectContext {
    
    func get<E, R>(request: NSFetchRequest<E>) async throws -> [R] where E: NSManagedObject, E: ThreadSafeable, R == E.SafeObject {
        try await self.perform { [weak self] in
            try self?.fetch(request).compactMap { $0.getSafeObject() } ?? []
        }
    }
}

enum SafeMapError: Error {
    case invalidMapping
}

protocol ThreadSafeable {
    associatedtype SafeObject
    func getSafeObject() -> SafeObject?
}
