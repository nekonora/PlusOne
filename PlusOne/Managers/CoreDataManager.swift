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
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            self.container.viewContext.automaticallyMergesChangesFromParent = true
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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
        DevLogger.shared.logMessage(.coreData(message: "Deleting \(String(describing: type(of: T.self)))"))
        saveContext()
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
            DevLogger.shared.logMessage(.coreData(message: "Context successfully saved!"))
        } catch {
            DevLogger.shared.logMessage(.coreData(message: error.localizedDescription))
        }
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
        DevLogger.shared.logMessage(.coreData(message: "Saving new counter \(counter.name)"))
        saveContext()
    }
    
    func editCounter(_ counter: Counter, with newConfig: CounterConfig) {
        counter.name = newConfig.name
        counter.currentValue = newConfig.currentValue
        counter.increment = newConfig.increment
        counter.completionValue = newConfig.completionValue ?? 0
        counter.createdAt = newConfig.createdAt
        counter.updatedAt = newConfig.updatedAt
        counter.unit = newConfig.unit
        DevLogger.shared.logMessage(.coreData(message: "Updating counter \(counter.name)"))
        saveContext()
    }
}
