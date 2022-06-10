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
            let counter = Counter(context: context)
            counter.createdAt = data.createdAt
            counter.id = data.id
            counter.value = data.value
            counter.name = data.name
            counter.steps = data.steps ?? 0
            counter.unit = data.unit
            counter.completionValue = data.completionValue ?? 0
            try context.save()
        }
    }
    
    func saveCounters(_ data: [CounterData]) async throws {
        
    }
    
    func updateCounter(_ id: UUID, with data: CounterData) async throws {
        
    }
    
    func deleteCounter(_ id: UUID) async throws {
        
    }
}
