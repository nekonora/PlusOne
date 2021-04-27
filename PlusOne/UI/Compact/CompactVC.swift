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
        let countersVC = CountersCollectionVC(viewModel: CountersCollectionVM())
        let countersNav = NavigationVC(rootViewController: countersVC)
        countersVC.navigationItem.title = R.string.localizable.tabBarCounters()
        countersVC.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTapped))
        ]
        countersVC.tabBarItem = UITabBarItem(title: R.string.localizable.tabBarCounters(), image: UIImage(systemSymbol: .squareStack3dDownRight), tag: 0)
        return countersNav
    }()
    
//    private lazy var tagsNav: UINavigationController = {
//        let tagsVC = UIViewController()
//        let tagsNav = NavigationVC(rootViewController: tagsVC)
//        tagsVC.navigationItem.title = R.string.localizable.tabBarTags()
//        tagsVC.tabBarItem = UITabBarItem(title: R.string.localizable.tabBarTags(), image: UIImage(systemSymbol: .tag), tag: 1)
//        return tagsNav
//    }()
    
    private lazy var automationNav: UINavigationController = {
        let statsVC = UIViewController()
        let automationNav = NavigationVC(rootViewController: statsVC)
        statsVC.navigationItem.title = R.string.localizable.tabBarAutomation()
        statsVC.tabBarItem = UITabBarItem(title: R.string.localizable.tabBarAutomation(), image: UIImage(systemSymbol: .waveformPathEcgRectangle), tag: 2)
    }()
    
    private lazy var settingsNav: UINavigationController = {
        let settingsVC = SettingsVC()
        let settingsNav = NavigationVC(rootViewController: settingsVC)
        settingsVC.navigationItem.title = R.string.localizable.tabBarSettings()
        settingsVC.tabBarItem = UITabBarItem(title: R.string.localizable.tabBarSettings(), image: UIImage(systemSymbol: .gear), tag: 3)
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
//            tagsNav,
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
