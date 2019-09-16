//
//  CountersListView.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 16/09/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import SwiftUI
import QGrid

struct CounterVM: Identifiable {
    var id: Int
    var name: String
}

struct CountersListUI: View {
    
    let counters: [CounterVM] = [
        .init(id: 0, name: "Test"),
        .init(id: 0, name: "Test"),
        .init(id: 0, name: "Test"),
        .init(id: 0, name: "Test"),
        .init(id: 0, name: "Test"),
        .init(id: 0, name: "Test"),
        .init(id: 0, name: "Test"),
        .init(id: 0, name: "Test"),
        .init(id: 0, name: "Test"),
        .init(id: 0, name: "Test"),
        .init(id: 0, name: "Test"),
        .init(id: 0, name: "Test"),
        .init(id: 0, name: "Test")
    ]
    
    var body: some View {
        QGrid(counters, columns: 3) { CounterCellUI(counter: $0) }
    }
}

struct CounterCellUI: View {
    
    var counter: CounterVM
    
    var body: some View {
        VStack() {
            Text(counter.name)
        }
    }
}

#if DEBUG
struct CountersListView_Previews: PreviewProvider {
    static var previews: some View {
        CountersListUI()
    }
}
#endif


