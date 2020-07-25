//
//  RegularSecondaryVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/06/2020.
//

import UIKit

// MARK: - Controller
final class RegularSecondaryVC: UIViewController {
    
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
        
        let addButton = UIBarButtonItem()
        
        addButton.primaryAction = UIAction(title: "", image: UIImage(systemName: "plus")) { [weak self] action in
            let newCounterVC = NewCounterVC()
            newCounterVC.modalPresentationStyle = .popover
            newCounterVC.popoverPresentationController?.barButtonItem = addButton
            self?.present(newCounterVC, animated: true, completion: nil)
        }
        
        navigationItem.leftBarButtonItems = [
            addButton
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
