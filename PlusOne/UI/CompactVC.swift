//
//  CompactVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/06/2020.
//

import UIKit

class CompactVC: UIViewController {

    // MARK: - UI
    private weak var countersCV: CountersCV!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup
private extension CompactVC {
    
    func setupUI() {
        navigationItem.title = "All"
        view.backgroundColor = UIColor.poBackground
        
        setupNavBar()
        addCollectionView()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTapped))
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

// MARK: - Actions
private extension CompactVC {
    
    @objc private func onAddTapped() {
        present(NewCounterVC(), animated: true, completion: nil)
    }
}
