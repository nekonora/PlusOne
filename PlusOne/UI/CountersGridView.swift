//
//  ContentView.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 01/06/22.
//

import SwiftUI
import CoreData

struct CountersGridView: View {
    
    @State private var spacing: CGFloat = 20
    @State private var minimiumItemWidth: CGFloat = 250
    @State private var showingSheet = false
    
    @ObservedObject var viewModel: CountersGridViewModel
    
    let title: String
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: minimiumItemWidth), spacing: spacing)], spacing: spacing) {
                ForEach(viewModel.counters) { counter in
                    CounterView(counter: counter)
                }
            }
            .padding()
        }
        .navigationTitle(title)
        .toolbar {
            #if DEBUG
            ToolbarItem(placement: .navigationBarLeading) {
                Stepper(value: $spacing) {
                    Text("\(Int(spacing))")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Stepper(value: $minimiumItemWidth) {
                    Text("\(Int(minimiumItemWidth))")
                }
            }
            #endif
            ToolbarItem {
                Button {
                    showingSheet.toggle()
                } label: {
                    Label("New Counter", systemImage: "plus")
                }
//                AsyncButton(action: viewModel.addCounter) {
//                    Label("Add Item", systemImage: "plus")
//                }
            }
        }
        .sheet(isPresented: $showingSheet) {
            EditCounterForm()
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
