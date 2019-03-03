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
	let noCountersView = UILabel()
	
	// Methods
    override func viewDidLoad() {
        super.viewDidLoad()
		
		collectionView.addSubview(noCountersView)
		
		dataSource.cellDelegate = self
		
		collectionView.dataSource = dataSource
		
		setupStyle()
    }
	
	
	override func viewWillAppear(_ animated: Bool) {
		setupView()
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
				self.setupView()
			}, completion: nil)
			
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	
	// Private methods
	
	fileprivate func setupView() {
		collectionView.reloadData()
		if dataSource.countersList.count == 0 {
			loadNoCounterAlert(bool: true)
		} else {
			loadNoCounterAlert(bool: false)
		}
	}
	
	
	fileprivate func setupStyle() {
		navigationController?.navigationBar.barStyle = .blackTranslucent
		navigationController?.navigationBar.barTintColor = UIColor(named: "notQuiteBlack")
		navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "notQuiteWhite")!]
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "notQuiteWhite")!]
		
		navigationItem.title = "My Counters"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
	}

	
	fileprivate func loadNoCounterAlert(bool: Bool) {
		if bool {
			noCountersView.isHidden = false
			collectionView.addSubview(noCountersView)
			
			noCountersView.translatesAutoresizingMaskIntoConstraints = false
			
			collectionView.addConstraints([
				NSLayoutConstraint(item: noCountersView, attribute: .centerX, relatedBy: .equal, toItem: collectionView, attribute: .centerX, multiplier: 1.0, constant: 0),
				NSLayoutConstraint(item: noCountersView, attribute: .centerY, relatedBy: .equal, toItem: collectionView, attribute: .centerY, multiplier: 1.0, constant: -100),
				NSLayoutConstraint(item: noCountersView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300),
				NSLayoutConstraint(item: noCountersView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
				])
			
			noCountersView.textColor 		= UIColor(named: "notQuiteWhite")!
			noCountersView.layer.opacity 	= 0.6
			noCountersView.textAlignment	= .center
			noCountersView.numberOfLines	= 0
			
			let attributedText = NSMutableAttributedString(
				string: "You don't have any counters at the moment.\n\nPlease tap the \"",
				attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)])
			
			attributedText.append(NSAttributedString(
				string: "Add",
				attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .heavy)]))
			
			attributedText.append(NSAttributedString(
				string: "\" button to add a counter.",
				attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]))
			
			noCountersView.attributedText = attributedText
			
			
			
		} else {
			noCountersView.isHidden = true
		}
	}
	
	
}
