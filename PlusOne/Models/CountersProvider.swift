//
//  CountersProvider.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 07/06/22.
//

import Foundation

protocol CountersProvider {
    func getCounters() async throws -> [CounterData]
    func getCounters(with predicate: NSPredicate) async throws -> [CounterData]
    func saveCounter(_ data: CounterData) async throws
    func saveCounters(_ data: [CounterData]) async throws
    func updateCounter(_ id: UUID, with data: CounterData) async throws
    func deleteCounter(_ id: UUID) async throws
}
