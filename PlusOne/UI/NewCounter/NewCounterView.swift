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
            Button("Cancel") {
                self.viewModel.dismiss?()
            }
            Spacer()
            Button(viewModel.editingCounter == nil ? "Add" : "Save") {
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
            Section(header: Text("Main info")) {
                HStack {
                    Text("Name")
                    Spacer()
                    TextField("New counter", text: $viewModel.name)
                        .multilineTextAlignment(.trailing)
                        .disableAutocorrection(true)
                }
                
                HStack {
                    Text("Initial value")
                    Spacer()
                    TextField("0", text: $viewModel.value)
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
        }
        .navigationBarTitle(viewModel.editingCounter == nil ? "New Counter" : "Edit Counter", displayMode: .inline)
        .navigationBarItems(leading:
                                Button("Cancel") {
                                    self.viewModel.dismiss?()
                                }
                            ,
                            trailing:
                                Button(viewModel.editingCounter == nil ? "Add" : "Save") {
                                    viewModel.saveCounter()
                                }.disabled(viewModel.name.isEmpty)
        )
    }
}
