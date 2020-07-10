//
//  MigrationAssistant.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 10/07/2020.
//

import Foundation

private struct LegacyModel: Codable {
    
    let id: UUID
    let name: String
    let value: Float
    let steps: Float
    let unit: String?
    let completionValue: Float?
}

class MigrationAssistant {
    
    // MARK: - Shared
    static let shared = MigrationAssistant()
    
    // MARK: - Methods
    func migrateDataIfPresent() {
        let oldData = loadFromDefaults()
        
        oldData.forEach {
            let config = CounterConfig(
                name: $0.name,
                currentValue: $0.value,
                increment: $0.steps,
                unit: $0.unit,
                completionValue: $0.completionValue,
                group: nil
            )
            CoreDataManager.shared.newCounter(config)
        }
        
        if oldData.hasSomething {
            Preferences.hasMigratedLegacyModel = true
            UserDefaults.standard.setValue(nil, forKey: "UserCounters")
            UserDefaults.standard.synchronize()
        }
    }
    
    // MARK: - Internal utils
    private func loadFromDefaults() -> [LegacyModel] {
        if let objects = UserDefaults.standard.value(forKey: "UserCounters") as? Data {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [LegacyModel] {
                return objectsDecoded
            } else {
                return []
            }
        } else {
            return []
        }
    }
}
