//
//  SceneDelegate.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/06/2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties
    var window: UIWindow?

    // MARK: - Scene lifecycle
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = RootVC(style: .doubleColumn)
            configureMac(on: windowScene)
            self.window = window
            window.makeKeyAndVisible()
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataManager.shared.saveContext()
    }
}

// MARK: - Catalyst
private extension SceneDelegate {
    
    func configureMac(on windowScene: UIWindowScene) {
        #if targetEnvironment(macCatalyst)
        let toolbar = NSToolbar()
        toolbar.delegate = self
        
        windowScene.titlebar?.toolbar = toolbar
        windowScene.titlebar?.toolbarStyle = .unified
        windowScene.titlebar?.titleVisibility = .hidden
        #endif
    }
}

// MARK: - NSToolBarDelegate
#if targetEnvironment(macCatalyst)
extension SceneDelegate: NSToolbarDelegate {
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            .toggleSidebar,
            .flexibleSpace,
            NSToolbarItem.Identifier("otherButton")
        ]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            .toggleSidebar,
            .flexibleSpace,
            NSToolbarItem.Identifier("otherButton")
        ]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        switch itemIdentifier {
        case NSToolbarItem.Identifier("otherButton"):
            let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(nop(_:)))
            return NSToolbarItem(itemIdentifier: itemIdentifier, barButtonItem: barButtonItem)
        default:
            break
        }
        
        return NSToolbarItem(itemIdentifier: itemIdentifier)
    }
    
    @objc func nop(_ sender : NSObject) {
        
    }
}
#endif
