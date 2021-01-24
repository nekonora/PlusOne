//
//  CounterPreviewView.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/07/2020.
//

import SwiftUI

struct CounterPreviewView: View {
    
    let counter: Counter
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    Text(counter.name)
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text(counter.uTags.first?.name ?? "")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                HStack {
                    Text("Current value:")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    if let unit = counter.unit {
                        Text(unit)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    
                    Text(counter.currentValue.stringTruncatingZero())
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                HStack {
                    Text("Increment:")
                        .foregroundColor(.white)
                    Spacer()
                    Text(counter.increment.stringTruncatingZero())
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                HStack {
                    Text("Completion value:")
                        .foregroundColor(.white)
                    Spacer()
                    Text(counter.completionValue.stringTruncatingZero())
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
            }.padding()
        }.background(Color(UIColor.poBackground3 ?? .white))
    }
}
