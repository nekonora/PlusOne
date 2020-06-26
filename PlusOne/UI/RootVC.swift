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
        preferredDisplayMode = .oneBesideSecondary
        
        primaryVC = RegularPrimaryVC()
        secondaryVC = RegularSecondaryVC()
        compactVC = CompactVC()
        
        setViewController(primaryVC, for: .primary)
        setViewController(secondaryVC, for: .secondary)
        setViewController(compactVC, for: .compact)
        
        /// macOS Sidebar styling
        primaryBackgroundStyle = .sidebar
    }
}

