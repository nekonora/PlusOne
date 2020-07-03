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
        if  let titlebar = windowScene.titlebar {
            let identifier = NSToolbar.Identifier("com.plusOne.toolbar")
            titlebar.toolbar = NSToolbar(identifier: identifier)
            titlebar.toolbar?.delegate = self
            titlebar.toolbarStyle = .unified
            titlebar.autoHidesToolbarInFullScreen = false
        }
        #endif
    }
}

// MARK: - NSToolBarDelegate
#if targetEnvironment(macCatalyst)
extension SceneDelegate: NSToolbarDelegate {
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
//            .composeIdentifier
        ]
    }
}
#endif
