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
        view.backgroundColor = UIColor.poBackground
        
        setupNavBar()
        addCollectionView()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: nil),
        ]
        
        let addCounterAction =  UIAction(title: "Add counter") { (action) in
            let config = CounterConfig(
                name: "Hey",
                currentValue: 0,
                increment: 0,
                completionValue: nil,
                group: nil
            )
            CoreDataManager.shared.newCounter(config)
        }
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Add", image: UIImage(systemName: "plus.circle.fill"), primaryAction: addCounterAction, menu: nil)
        ]
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
