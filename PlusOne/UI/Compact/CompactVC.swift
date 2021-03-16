//
//  CompactVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/06/2020.
//

import UIKit

final class CompactVC: UITabBarController {
    
    // MARK: - UI
    private lazy var countersNav: UINavigationController = {
        let countersVC = CountersCollectionVC()
        let countersNav = NavigationVC(rootViewController: countersVC)
        countersVC.navigationItem.title = countersVC.strings.title
        countersVC.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTapped))
        ]
        countersVC.tabBarItem = UITabBarItem(title: countersVC.strings.title, image: UIImage(systemName: "square.stack.3d.down.right"), tag: 0)
        return countersNav
    }()
    
    private lazy var tagsNav: UINavigationController = {
        let tagsVC = UIViewController()
        let tagsNav = NavigationVC(rootViewController: tagsVC)
        tagsVC.navigationItem.title = "Tags"
        tagsVC.tabBarItem = UITabBarItem(title: "Tags", image: UIImage(systemName: "tag"), tag: 1)
        return tagsNav
    }()
    
    private lazy var automationNav: UINavigationController = {
        let statsVC = UIViewController()
        let automationNav = NavigationVC(rootViewController: statsVC)
        statsVC.navigationItem.title = "Automation"
        statsVC.tabBarItem = UITabBarItem(title: "Stats", image: UIImage(systemName: "waveform.path.ecg.rectangle"), tag: 2)
    }()
    
    private lazy var settingsNav: UINavigationController = {
        let settingsVC = SettingsVC()
        let settingsNav = NavigationVC(rootViewController: settingsVC)
        settingsVC.navigationItem.title = settingsVC.strings.title
        settingsVC.tabBarItem = UITabBarItem(title: settingsVC.strings.title, image: UIImage(systemName: "gear"), tag: 3)
        return settingsNav
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup
private extension CompactVC {
    
    func setupUI() {
        view.backgroundColor = UIColor.poBackground
        
        viewControllers = [
            countersNav,
            tagsNav,
            settingsNav
        ]
    }
}

// MARK: - Actions
private extension CompactVC {
    
    @objc private func onAddTapped() {
        let newCounterVC = NewCounterVC()
        present(newCounterVC, animated: true, completion: nil)
    }
}
