//
//  Persistence.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 01/06/22.
//

import CoreData

enum PersistenceError: LocalizedError {
    case objectNotFound
    
    var errorDescription: String? {
        switch self {
        case .objectNotFound: return "Object does not exist in database"
        }
    }
}

struct PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: Config.containerIdentifier)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}