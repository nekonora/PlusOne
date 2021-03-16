//
//  NavigationVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 16/03/21.
//

import UIKit

final class NavigationVC: UINavigationController {
    
    var navbarColor: UIColor = .secondarySystemBackground
    var titleColor: UIColor = .label
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: titleColor]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
        navBarAppearance.backgroundColor = navbarColor
        navBarAppearance.shadowColor = nil
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationBar.prefersLargeTitles = true
    }
}
