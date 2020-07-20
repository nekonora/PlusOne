//
//  CoreDataManager.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 26/06/2020.
//

import CoreData
import Foundation

class CoreDataManager {
    
    // MARK: - Instance
    static let shared = CoreDataManager()
    
    // MARK: - Public properties
    var context: NSManagedObjectContext { container.viewContext }
    
    // MARK: - Public methods
    func setup(with persistentContainer: NSPersistentContainer) {
        container = persistentContainer
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func createFetch<T: NSManagedObject>(for name: String?, dateSorted: Bool) -> NSFetchRequest<T> {
        let fetchRequest = NSFetchRequest<T>(entityName: T.typeName)
        fetchRequest.predicate = name != nil ? NSPredicate(format: "name == %@", name!) : nil
        fetchRequest.sortDescriptors = dateSorted ? [NSSortDescriptor(key: "updatedAt", ascending: false)] : []
        return fetchRequest
    }
    
    func delete<T: NSManagedObject>(object: T) {
        context.delete(object)
        saveContext()
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        try? context.save()
    }
    
    // MARK: - Private properties
    private var container: NSPersistentContainer!
}
 
// MARK: - Counters storage
extension CoreDataManager {
    
    func newCounter(_ config: CounterConfig) {
        let counter = Counter(context: context)
        counter.identifier = UUID()
        counter.name = config.name
        counter.currentValue = config.currentValue
        counter.increment = config.increment
        counter.completionValue = config.completionValue ?? 0
        counter.createdAt = config.createdAt
        counter.updatedAt = config.updatedAt
        counter.unit = config.unit
        saveContext()
    }
}
