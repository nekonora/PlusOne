//
//  AppDelegate.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/06/2020.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupCoreData()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Root", sessionRole: .windowApplication)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}

// MARK: - Setup
private extension AppDelegate {
    
    func setupCoreData() {
        #if targetEnvironment(simulator)
        let container = NSPersistentContainer(name: "PlusOne")
        #else
        let container = NSPersistentCloudKitContainer(name: "PlusOne")
        #endif
        CoreDataManager.shared.setup(with: container)
    }
}
