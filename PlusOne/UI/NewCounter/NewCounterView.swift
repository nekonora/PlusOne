//
//  NewCounterView.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 10/07/2020.
//

import SwiftUI
import Combine

struct NewCounterView: View {
    
    // MARK: - Properties
    @State var name: String = ""
    @State var value: String = ""
    @State var increment: String = ""
    @State var unit: String = ""
    @State var completionValue: String = ""
    
    var dismiss: (() -> Void)?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Main info")) {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("New counter", text: $name)
                            .multilineTextAlignment(.trailing)
                            .disableAutocorrection(true)
                    }
    
                    HStack {
                        Text("Initial value")
                        Spacer()
                        TextField("0", text: $value)
                            .keyboardType(.numberPad)
                            .onReceive(Just(value)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue { self.value = filtered }
                            }
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("Other")) {
                    HStack {
                        Text("Increment")
                        Spacer()
                        TextField("1", text: $increment)
                            .keyboardType(.numberPad)
                            .onReceive(Just(increment)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue { self.increment = filtered }
                            }
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Unit")
                        Spacer()
                        TextField("", text: $unit)
                            .onReceive(Just(unit)) { newValue in
                                let filtered = String(newValue.prefix(2))
                                if filtered != newValue { self.unit = filtered }
                            }
                            .multilineTextAlignment(.trailing)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                    }
                    HStack {
                        Text("Completion value")
                        Spacer()
                        TextField("", text: $completionValue)
                            .keyboardType(.numberPad)
                            .onReceive(Just(completionValue)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue { self.completionValue = filtered }
                            }
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .navigationBarTitle("New counter", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button("Cancel") {
                                        self.dismiss?()
                                    }
                                ,
                                trailing:
                                    Button("Add") {
                                        let config = CounterConfig(
                                            name: self.name,
                                            currentValue: self.value.floatValue ?? 0,
                                            increment: self.increment.floatValue ?? 1,
                                            unit: self.unit.nilIfEmpty,
                                            completionValue: self.completionValue.floatValue,
                                            group: nil
                                        )
                                        CoreDataManager.shared.newCounter(config)
                                        self.dismiss?()
                                    }.disabled(name.isEmpty)
            )
        }
    }
}

struct NewCounterView_Previews: PreviewProvider {
    static var previews: some View {
        NewCounterView()
            .previewDevice("iPhone 8")
            .previewLayout(.device)
            
    }
}
