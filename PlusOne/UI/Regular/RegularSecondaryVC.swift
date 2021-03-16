//
//  RegularSecondaryVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/06/2020.
//

import Combine
import UIKit

// MARK: - Controller
final class RegularSecondaryVC: UIViewController {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI
    private weak var countersCV: CountersCollectionVC!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObservables()
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
        
        addButton.primaryAction = UIAction(title: "", image: UIImage(systemName: "plus")) { [weak self] _ in
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
        let vc = CountersCollectionVC()
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        vc.view.fillSuperview()
        countersCV = vc
    }
    
    func setupObservables() {
        NotificationCenter.default.publisher(for: .addCounter)
            .receive(on: RunLoop.main)
            .sink { _ in self.onAddTapped() }
            .store(in: &cancellables)
    }
}

// MARK: - Actions
private extension RegularSecondaryVC {
    
    @objc private func onAddTapped() {
        let newCounterVC = NewCounterVC()
        present(newCounterVC, animated: true, completion: nil)
    }
}
