//
//  NewCounterView.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 10/07/2020.
//

import SwiftUI
import Combine

struct NewCounterView: View {
    
    // MARK: - ViewModel
    @ObservedObject var viewModel: NewCounterVM
    
    // MARK: - Body
    var body: some View {
        #if targetEnvironment(macCatalyst)
        CounterForm(viewModel: viewModel)
        HStack {
            Button(R.string.localizable.alertCancel()) {
                self.viewModel.dismiss?()
            }
            Spacer()
            Button(viewModel.editingCounter == nil ? R.string.localizable.newCounterAdd() : R.string.localizable.newCounterSave()) {
                viewModel.saveCounter()
            }.disabled(viewModel.name.isEmpty)
        }.padding()
        #else
        NavigationView {
            CounterForm(viewModel: viewModel)
        }
        #endif
    }
}

// MARK: - Subviews
private struct CounterForm: View {
    
    // MARK: - ViewModel
    @ObservedObject var viewModel: NewCounterVM
    
    var body: some View {
        Form {
            Section(header: Text(R.string.localizable.newCounterMainInfoSectionTitle())) {
                HStack {
                    Text(R.string.localizable.newCounterMainInfoNameLabel())
                    Spacer()
                    TextField(R.string.localizable.newCounterMainInfoNamePlaceholder(), text: $viewModel.name)
                        .multilineTextAlignment(.trailing)
                        .disableAutocorrection(true)
                }
                
                HStack {
                    Text(R.string.localizable.newCounterMainInfoInitialValueLabel())
                    Spacer()
                    TextField(R.string.localizable.newCounterMainInfoInitialValuePlaceholder(), text: $viewModel.value)
                        .keyboardType(.numberPad)
                        .onReceive(Just(viewModel.value)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue { self.viewModel.value = filtered }
                        }
                        .multilineTextAlignment(.trailing)
                }
            }
            
            Section(header: Text("Other")) {
                HStack {
                    Text("Increment")
                    Spacer()
                    TextField("1", text: $viewModel.increment)
                        .keyboardType(.numberPad)
                        .onReceive(Just(viewModel.increment)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue { self.viewModel.increment = filtered }
                        }
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Unit")
                    Spacer()
                    TextField("", text: $viewModel.unit)
                        .onReceive(Just(viewModel.unit)) { newValue in
                            let filtered = String(newValue.prefix(2))
                            if filtered != newValue { self.viewModel.unit = filtered }
                        }
                        .multilineTextAlignment(.trailing)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                HStack {
                    Text("Completion value")
                    Spacer()
                    TextField("", text: $viewModel.completionValue)
                        .keyboardType(.numberPad)
                        .onReceive(Just(viewModel.completionValue)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue { self.viewModel.completionValue = filtered }
                        }
                        .multilineTextAlignment(.trailing)
                }
            }
            
            Section(header: Text("Tags")) {
                TagsContainer(viewModel: viewModel)
            }
        }
        .navigationBarTitle(viewModel.editingCounter == nil ? "New Counter" : "Edit Counter", displayMode: .inline)
        .navigationBarItems(
            leading:
                Button("Cancel") {
                    self.viewModel.dismiss?()
                }
            ,
            trailing:
                Button(viewModel.editingCounter == nil ? "Add" : "Save") {
                    viewModel.saveCounter()
                }
                .disabled(viewModel.name.isEmpty)
        )
    }
}

private struct TagsContainer: View {
    
    // MARK: - ViewModel
    @ObservedObject var viewModel: NewCounterVM
    
    var body: some View {
        if viewModel.tags.isEmpty {
            Button("Add Tags") {
                viewModel.tags = askForTags()
            }
        } else {
            Button("Edit Tags") {
                
            }
        }
    }
    
    func askForTags() -> [Tag] {
        []
    }
}
