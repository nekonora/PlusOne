//
//  RegularSecondaryVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/06/2020.
//

import UIKit

class RegularSecondaryVC: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup
private extension RegularSecondaryVC {
    
    func setupUI() {
        navigationItem.title = "All counters"
        view.backgroundColor = UIColor.poBackground
        setupNavBar()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTapped))
        ]
    }
}

// MARK: - Actions
private extension RegularSecondaryVC {
    
    @objc private func onAddTapped() {
        
    }
}
