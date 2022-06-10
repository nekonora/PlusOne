//
//  MigrationManager.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 09/06/22.
//

import Foundation
import DefaultsWrapper

struct MigrationManager {
    
    struct DefaultsCounter: Codable {
        let id: UUID
        let name: String
        let value: Float
        let steps: Float
        let unit: String
        let completionValue: Float
    }
    
    #warning("TODO: put this in an initial loader or something")
    func handlePossibleMigration() async throws {
        guard Preferences.App.oldModelDefaults != nil else { return }
        let data = getOldDataFromDefaults()
        try await CountersManager.shared.saveCounters(data)
        Preferences.App.resetKeys(for: [.oldModelDefaults])
    }
    
    private func getOldDataFromDefaults() -> [CounterData] {
        let oldData = getOldData()
        return oldData.map {
            CounterData(
                id: $0.id,
                createdAt: Date(),
                modifiedAt: Date(),
                name: $0.name,
                value: Double($0.value),
                steps: Double($0.steps).nilIfZero,
                unit: $0.unit.nilIfEmpty,
                completionValue: Double($0.completionValue).nilIfZero
            )
        }
    }
    
    private func getOldData() -> [DefaultsCounter] {
        guard let objects = Preferences.App.oldModelDefaults else {
            return []
        }
        
        let decoder = JSONDecoder()
        if let objectsDecoded = try? decoder.decode (Array.self, from: objects) as [DefaultsCounter] {
            return objectsDecoded
        } else {
            return []
        }
    }
}
