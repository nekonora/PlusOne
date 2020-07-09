//
//  RegularSecondaryVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/06/2020.
//

import UIKit

// MARK: - Controller
class RegularSecondaryVC: UIViewController {
    
    // MARK: - UI
    private weak var countersCV: CountersCV!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup
private extension RegularSecondaryVC {
    
    func setupUI() {
        navigationItem.title = "All"

        #if targetEnvironment(macCatalyst)
        hideNavBar()
        #else
        setupNavBar()
        view.backgroundColor = UIColor.poBackground
        #endif
        addCollectionView()
    }
    
    func hideNavBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addCounterAction = UIAction(title: "Add counter") { (action) in
            let config = CounterConfig(
                name: "Hey",
                currentValue: 0,
                increment: 0,
                completionValue: nil,
                group: nil
            )
            CoreDataManager.shared.newCounter(config)
        }
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Add", image: UIImage(systemName: "plus"), primaryAction: addCounterAction, menu: nil),
            UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: nil),
        ]
        
        let searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        searchBar.placeholder = "Search"
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        navigationItem.rightBarButtonItem = leftNavBarButton
    }
    
    func addCollectionView() {
        let vc = CountersCV()
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        vc.view.fillSuperview()
        countersCV = vc
    }
}
