//
//  MainSplitView.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 08/06/22.
//

import SwiftUI

struct MainSplitView: View {
    
    enum SidebarSelection: CaseIterable {
        var title: String {
            switch self {
            case .counters: return "Counters"
            case .tags: return "Tags"
            case .settings: return "Settings"
            }
        }
        
        case counters, tags, settings
    }
    
    @State private var selectedTab: SidebarSelection = .counters
    
    var body: some View {
        NavigationSplitView {
            List(SidebarSelection.allCases, id:\.self, selection: $selectedTab) { selection in
                NavigationLink(value: selection) {
                    Text(selection.title)
                }
            }
            .navigationTitle("PlusOne")
        } detail: {
            switch selectedTab {
            case .counters:
                CountersGridView(viewModel: CountersGridViewModel(), title: "Counters")
            case .tags:
                Text("Tags here")
            case .settings:
                Text("Settings here")
            }
        }
    }
}
