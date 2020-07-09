//
//  RootVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/06/2020.
//

import UIKit

class RootVC: UISplitViewController {
    
    // MARK: - Controllers
    var primaryVC: RegularPrimaryVC! = nil
    var secondaryVC: RegularSecondaryVC! = nil
    var compactVC: CompactVC! = nil

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        primaryVC = RegularPrimaryVC()
        secondaryVC = RegularSecondaryVC()
        compactVC = CompactVC()
        
        #if targetEnvironment(macCatalyst)
        viewControllers = [primaryVC, secondaryVC]
        #else
        preferredDisplayMode = .oneBesideSecondary
        setViewController(primaryVC, for: .primary)
        setViewController(secondaryVC, for: .secondary)
        setViewController(UINavigationController(rootViewController: compactVC), for: .compact)
        #endif
        
        /// macOS Sidebar styling
        primaryBackgroundStyle = .sidebar
    }
}

