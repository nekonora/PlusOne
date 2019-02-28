//
//  CountersCVC.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 04/02/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


class CountersCVC: UICollectionViewController {

	
	// Properties
	var dataSource = CountersDataSource()
	
	
	// Methods
    override func viewDidLoad() {
        super.viewDidLoad()
		
		dataSource.cellDelegate = self
		
		collectionView.dataSource = dataSource
		
		setupStyle()
    }
	
	
	override func viewWillAppear(_ animated: Bool) {
		collectionView.reloadData()
	}
	
	
	// UI methods
	@objc func addTapped() {
		let alert = UIAlertController(title: "Name", message: "Enter a name for the counter", preferredStyle: .alert)
		
		alert.addTextField { (textField) in
			textField.text = ""
			textField.keyboardAppearance = UIKeyboardAppearance.dark
		}
		
		alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
			let textField 	= alert?.textFields![0]
			self.dataSource.addCounter(with: textField!.text!)
			
			let indexPath = IndexPath(
				item: 0,
				section: 0
			)
			
			self.collectionView.performBatchUpdates({
				self.collectionView?.insertItems(at: [indexPath])
			}, completion: nil)
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	
	// Private methods
	fileprivate func setupStyle() {
		navigationController?.navigationBar.barStyle = .blackTranslucent
		navigationController?.navigationBar.barTintColor = UIColor(named: "notQuiteBlack")
		navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "notQuiteWhite")!]
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "notQuiteWhite")!]
		
		navigationItem.title = "My Counters"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
	}

	
}
