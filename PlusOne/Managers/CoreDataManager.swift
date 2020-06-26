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
        })
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.automaticallyMergesChangesFromParent = true
    }
    
    func saveContext () {
        guard context.hasChanges else { return }
        try? context.save()
    }
    
    // MARK: - Private properties
    private var container: NSPersistentContainer!
}
