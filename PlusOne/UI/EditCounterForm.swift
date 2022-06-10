//
//  EditCounterForm.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 08/06/22.
//

import SwiftUI

struct EditCounterForm: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var value: Double?
    @State private var steps: Double?
    @State private var unit: String = ""
    @State private var completionValue: Double?
    
    private var isValid: Bool {
        let mandatoryValid = name.nilIfEmpty != nil
        let stepsValid = (steps ?? 1) != 0
        return mandatoryValid && stepsValid
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $name)
                }
                
                Section("Optional") {
                    TextField("Current value", value: $value, format: .number)
                    TextField("Steps", value: $steps, format: .number)
                    TextField("Unit", text: $unit)
                    TextField("Completion value", value: $completionValue, format: .number)
                }
                
                if let completionValue {
                    Section("Completion") {
                        ProgressView(value: min(value ?? 0, completionValue), total: completionValue)
                    }
                }
                
                #if DEBUG
                Section("DEBUG INFO") {
                    LabeledContent("setTitle", value: name.nilIfEmpty ?? "not set")
                    LabeledContent("setValue", value: "\(value ?? 0)")
                    LabeledContent("setSteps", value: "\(steps ?? 0)")
                    LabeledContent("setUnit", value: unit.nilIfEmpty ?? "not set")
                    LabeledContent("VALID FORM", value: isValid ? "VALID" : "NOT VALID")
                }
                #endif
            }
            .formStyle(.grouped)
            .navigationTitle("New Counter")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage: "multiply")
                    }
                }
                ToolbarItem {
                    AsyncButton(action: saveCounter) {
                        Text("Save")
                    }
                }
            }
        }
    }
    
    private func saveCounter() async {
        let data = CounterData(
            id: UUID(),
            createdAt: Date(),
            name: name,
            value: value ?? 0,
            steps: steps,
            unit: unit,
            completionValue: completionValue
        )
        do {
            try await CountersManager.shared.saveCounter(data)
            dismiss()
        } catch {
            #warning("TODO: handle error")
        }
    }
}

struct EditCounterForm_Previews: PreviewProvider {
    static var previews: some View {
        EditCounterForm()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
