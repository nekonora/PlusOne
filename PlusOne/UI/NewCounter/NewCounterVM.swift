//
//  NewCounterVM.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/07/2020.
//

import Foundation
import Combine

class NewCounterVM: ObservableObject {
    
    // MARK: - Properties
    @Published var name: String
    @Published var value: String
    @Published var increment: String
    @Published var unit: String
    @Published var completionValue: String
    
    let editingCounter: Counter?
    var dismiss: (() -> Void)?
    
    // MARK: - Init
    init(counterToEdit: Counter? = nil, onDismiss: (() -> Void)? = nil) {
        self.editingCounter = counterToEdit
        self.dismiss = onDismiss
        self.name = counterToEdit?.name ?? ""
        self.value = counterToEdit?.currentValue.stringTruncatingZero() ?? ""
        self.increment = counterToEdit?.increment.stringTruncatingZero() ?? ""
        self.unit = counterToEdit?.unit ?? ""
        self.completionValue = counterToEdit?.completionValue.stringTruncatingZero() ?? ""
    }
    
    // MARK: - Methods
    func saveCounter() {
        let config = CounterConfig(
            name: self.name,
            currentValue: self.value.floatValue ?? 0,
            increment: self.increment.floatValue ?? 1,
            unit: self.unit.nilIfEmpty,
            completionValue: self.completionValue.floatValue,
            group: nil
        )
        
        if let counterToEdit = editingCounter {
            CoreDataManager.shared.editCounter(counterToEdit, with: config)
        } else {
            CoreDataManager.shared.newCounter(config)
        }
        self.dismiss?()
    }
}
