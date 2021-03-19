//
//  ToolbarDelegate.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 28/07/20.
//

import UIKit

class ToolbarDelegate: NSObject { }

#if targetEnvironment(macCatalyst)

// MARK: - Toolbar Itentifiers
extension NSToolbarItem.Identifier {
    static let addCounter = NSToolbarItem.Identifier("NknrDev.QuickCounter.addCounter")
}

// MARK: - Actions
extension ToolbarDelegate {
    
    @objc func addCounter(_ sender: Any?) {
        NotificationCenter.default.post(name: .addCounter, object: self)
    }
}

// MARK: - NSToolbarDelegate
extension ToolbarDelegate: NSToolbarDelegate {
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            .toggleSidebar,
            .flexibleSpace,
            .addCounter
        ]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        toolbarDefaultItemIdentifiers(toolbar)
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        var toolbarItem: NSToolbarItem?
        
        switch itemIdentifier {
        case .toggleSidebar:
            toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        case .addCounter:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.image = UIImage(systemSymbol: .plus)
            item.label = R.string.localizable.macToolbarAddCounter()
            item.action = #selector(addCounter(_:))
            item.target = self
            toolbarItem = item
        default:
            toolbarItem = nil
        }
        
        return toolbarItem
    }
}
#endif
