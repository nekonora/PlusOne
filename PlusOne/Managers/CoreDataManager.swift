//
//  CoreDataManager.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 26/06/2020.
//

import CoreData
import Foundation

enum CoreDataError: LocalizedError {
    case creatingDuplicate
    case cannotFetch(type: String)
    
    var errorDescription: String? {
        switch self {
        case .creatingDuplicate: return "Creating duplicate tag"
        case .cannotFetch(let type): return "Cannot fetch: \(type)"
        }
    }
}

final class CoreDataManager {
    
    // MARK: - Instance
    static let shared = CoreDataManager()
    
    private init() { }
    
    // MARK: - Properties
    var context: NSManagedObjectContext { container.viewContext }
    
    private var container: NSPersistentContainer!
    
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
    
    func createGenericFetch<T: NSManagedObject>(predicate: NSPredicate, dateSorted: Bool) -> NSFetchRequest<T> {
        let fetchRequest = NSFetchRequest<T>(entityName: T.typeName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = dateSorted ? [NSSortDescriptor(key: "date", ascending: false)] : []
        return fetchRequest
    }
    
    func delete<T: NSManagedObject>(object: T) {
        if let counter = object as? Counter, let changes = counter.changes?.allObjects as? [ChangeRecord] {
            changes.forEach { context.delete($0) }
        }
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
        counter.tags = config.tags
        DevLogger.shared.logMessage(.coreData(message: "Saving new counter \(counter.name)"))
        saveContext()
    }
    
    func editCounter(_ counter: Counter, with newConfig: CounterConfig) {
        if counter.currentValue != newConfig.currentValue {
            let changeRecord = ChangeRecord(context: context)
            changeRecord.key = "currentValue"
            changeRecord.newValue = newConfig.currentValue
            changeRecord.oldValue = counter.currentValue
            changeRecord.date = Date()
            counter.addToChanges(changeRecord)
        }
        
        counter.name = newConfig.name
        counter.currentValue = newConfig.currentValue
        counter.increment = newConfig.increment
        counter.completionValue = newConfig.completionValue ?? 0
        counter.createdAt = newConfig.createdAt
        counter.updatedAt = newConfig.updatedAt
        counter.unit = newConfig.unit
        counter.tags = newConfig.tags
        
        DevLogger.shared.logMessage(.coreData(message: "Updating counter \(counter.name)"))
        saveContext()
    }
    
    func updateCounterValue(_ counter: Counter, to newValue: Float) {
        let changeRecord = ChangeRecord(context: context)
        changeRecord.key = "currentValue"
        changeRecord.newValue = newValue
        changeRecord.oldValue = counter.currentValue
        changeRecord.date = Date()
        
        counter.currentValue = newValue
        counter.addToChanges(changeRecord)
        DevLogger.shared.logMessage(.coreData(message: "Updating counter \(counter.name) value to \(newValue)"))
        saveContext()
    }
}

// MARK: - TagsStorage
extension CoreDataManager {
    
    func newTag(named name: String) throws {
        do {
            let allTags = try getAllTags()
            if allTags.contains(where: { $0.name == name }) {
                throw CoreDataError.creatingDuplicate
            }
        } catch {
            throw error
        }
        
        let tag = Tag(context: context)
        tag.identifier = UUID()
        tag.name = name
//        tag.color = 
        DevLogger.shared.logMessage(.coreData(message: "Saving new tag \(name)"))
        saveContext()
    }
    
    func getAllTags() throws -> Set<Tag> {
        do {
            let tagFetch = createFetch(for: nil, dateSorted: false) as NSFetchRequest<Tag>
            let tags = try context.fetch(tagFetch) as [Tag]
            return Set(tags)
        } catch {
            throw CoreDataError.cannotFetch(type: "tags")
        }
    }
}
