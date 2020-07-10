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
                    }
    
                    HStack {
                        Text("Initial value")
                        Spacer()
                        TextField("0", text: $value)
                            .keyboardType(.numberPad)
                            .onReceive(Just(value)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.value = filtered
                                }
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
                                            currentValue: self.value.floatValue,
                                            increment: 1,
                                            unit: nil,
                                            completionValue: nil,
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
