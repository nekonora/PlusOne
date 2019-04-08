//
//  CountersCVC.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 04/02/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


class CountersCVC: UICollectionViewController {

	
	// MARK: - Properties
	let theme 			= ThemeManager.currentTheme()
	var dataSource 		= CountersDataSource()
	let noCountersView 	= UILabel()
	
	
	// MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
		collectionView.dataSource = dataSource
		collectionView?.register(TagHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "tagHeader")
		collectionView.addSubview(noCountersView)
    }
	
	
	override func viewWillAppear(_ animated: Bool) {
		setupView()
	}
	
	
	// MARK: - Private methods
	func setupView() {
		setupTheme()
		collectionView.reloadData()
		if dataSource.countersList.count == 0 {
			loadNoCounterView(bool: true)
		} else {
			loadNoCounterView(bool: false)
		}
	}
	
	
	fileprivate func setupTheme() {
		collectionView.backgroundColor = theme.backgroundColor
	}
	
	
	fileprivate func loadNoCounterView(bool: Bool) {
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
			
			noCountersView.textColor 		= theme.textColor
			noCountersView.layer.opacity 	= 0.6
			noCountersView.textAlignment	= .center
			noCountersView.numberOfLines	= 0
			
			let attributedText = NSMutableAttributedString(
				string: "You don't have any counters at the moment.\n\nPlease tap the \"",
				attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)])
			
			attributedText.append(NSAttributedString(
				string: "Counters",
				attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .heavy)]))
			
			attributedText.append(NSAttributedString(
				string: "\" button to add a new counter.",
				attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]))
			
			noCountersView.attributedText = attributedText
			
		} else {
			noCountersView.isHidden = true
		}
	}
	
	
}
