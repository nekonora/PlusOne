//
//  CompactVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/06/2020.
//

import UIKit

final class CompactVC: UITabBarController {
    
    // MARK: - UI
    
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
        
        setupViewControllers()
    }
    
    func setupViewControllers() {
        let countersVC = CountersCV()
        let countersNav = UINavigationController(rootViewController: countersVC)
        countersVC.navigationItem.title = "All"
        countersVC.navigationController?.navigationBar.prefersLargeTitles = true
        countersVC.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTapped))
        ]
        countersVC.tabBarItem = UITabBarItem(title: "Counters", image: UIImage(systemName: "square.stack.3d.down.right"), tag: 0)
        
        let tagsVC = UIViewController()
        tagsVC.tabBarItem = UITabBarItem(title: "Tags", image: UIImage(systemName: "tag"), tag: 1)
        
        let statsVC = UIViewController()
        statsVC.tabBarItem = UITabBarItem(title: "Stats", image: UIImage(systemName: "waveform.path.ecg.rectangle"), tag: 2)
        
        let settingsVC = SettingsVC()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 3)
        
        viewControllers = [
            countersNav,
            tagsVC,
            statsVC,
            settingsVC
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
