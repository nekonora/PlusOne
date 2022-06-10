//
//  CountersManager.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 02/06/22.
//

import Foundation
import CoreData

struct CountersManager: CountersProvider {
    
    static let shared = CountersManager()

    private let persistence: PersistenceController
    private var context: NSManagedObjectContext {
        persistence.container.viewContext
    }
    
    init(persistence: PersistenceController = .shared) {
        self.persistence = persistence
    }
    
    func getCounters() async throws -> [CounterData] {
        try await context.get(request: Counter.fetchRequest())
    }
    
    func getCounters(with predicate: NSPredicate) async throws -> [CounterData] {
        try await context.get(request: Counter.fetchRequest())
    }
    
    func saveCounter(_ data: CounterData) async throws {
        try await context.perform {
            _ = data.getCDObject(for: context)
            try context.save()
        }
    }
    
    func saveCounters(_ data: [CounterData]) async throws {
        try await context.perform {
            _ = data.compactMap {
                $0.getCDObject(for:context)
            }
            try context.save()
        }
    }
    
    func updateCounter(_ id: UUID, with data: CounterData) async throws {
        let counter = try await getCounterById(id.uuidString)
        counter.createdAt = data.createdAt
        counter.value = data.value
        counter.name = data.name
        counter.steps = data.steps ?? 1
        counter.unit = data.unit
        counter.completionValue = data.completionValue ?? 0
        counter.modifiedAt = Date()
        try await context.perform {
            try context.save()
        }
    }
    
    func updateCounterValue(id: UUID, opearation: CounterOperation) {
        Task {
            let counter = try await getCounterById(id.uuidString)
            try await context.perform {
                switch opearation {
                case .increase:
                    counter.value += counter.steps
                case .decrease:
                    counter.value -= counter.steps
                }
                try context.save()
            }
        }
    }
    
    func deleteCounter(_ id: UUID) async throws {
        let counter = try await getCounterById(id.uuidString)
        try await context.perform {
            context.delete(counter)
            try context.save()
        }
    }
    
    private func getCounterById(_ id: String) async throws -> Counter {
        let request = Counter.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        return try await context.perform {
            if let counter = try context.fetch(request).first {
                return counter
            } else {
                throw PersistenceError.objectNotFound
            }
        }
    }
}
