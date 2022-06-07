//
//  ContentView.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 01/06/22.
//

import SwiftUI
import CoreData

struct CountersListView: View {
    
    @ObservedObject
    var viewModel: CountersListViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.counters) { counter in
                    NavigationLink {
                        Text("Item at \(counter.createdAt, formatter: itemFormatter)")
                    } label: {
                        Text(counter.createdAt, formatter: itemFormatter)
                    }
                }
//                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    AsyncButton(action: viewModel.addCounter) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
