//
//  CountersGridViewModel.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 07/06/22.
//

import Combine
import Foundation

final class CountersGridViewModel: ObservableObject {
    
    // MARK: - Properties
    private let countersProvider: CountersProvider
    private var disposeBag = Set<AnyCancellable>()
    
    @Published
    private(set) var counters: [CounterData] = []
    
    // MARK: - Init
    init(countersProvider: CountersProvider = CountersManager()) {
        self.countersProvider = countersProvider
        let fetchRequest = Counter.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Counter.createdAt, ascending: false)
        ]
        CDPublisher(request: fetchRequest, context: PersistenceController.shared.container.viewContext)
            .map { objs in
                objs.compactMap { $0.getSafeObject() }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] value in
                self?.counters = value
            })
            .store(in: &disposeBag)
    }
    
    // MARK: - Methods
}
