//
//  CounterView.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 02/06/22.
//

import SwiftUI

struct CounterView: View {
    
    let counter: CounterData
    @State private var value: Double = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.tertiary.shadow(.drop(color: .black, radius: 30, y: 10)).opacity(0.2))
            
            VStack(alignment: .leading) {
                Text(counter.name)
                HStack {
                    
                }
                
                Spacer()
                
                if let completion = counter.completionValue {
                    ProgressView(value: counter.value, total: completion)
                } else {
                    Divider()
                        .frame(maxWidth: 80)
                }
                
                HStack {
                    Text("\(counter.value)")
                    Stepper(value: $value) {
                        Text("")
                    }
                }
            }
            .padding(20)
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    
    static var previews: some View {
        CounterView(counter: Mocks.counterSimple)
            .previewLayout(.fixed(width: 280, height: 150))
            .padding()
    }
}
