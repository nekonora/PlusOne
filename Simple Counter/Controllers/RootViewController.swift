//
//  RootViewController.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 16/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit
import Menu


class RootViewController: UIViewController {
	
	
	// MARK: - Outlets
	@IBOutlet var stackView: UIStackView!
	@IBOutlet var collectionViewContainer: UIView!
	

	// MARK: - Properties
	var countersCollection: CountersCVC {
		get {
			let ctrl = children.first(where: { $0 is CountersCVC })
			return ctrl as! CountersCVC
		}
	}
	
	var smallLayout: UICollectionViewFlowLayout {
		let _flowLayout 					= UICollectionViewFlowLayout()
		_flowLayout.itemSize 				= CGSize(width: 176, height: 170)
		_flowLayout.sectionInset 			= UIEdgeInsets(top: 10, left: 5, bottom: 20, right: 5)
		_flowLayout.scrollDirection 		= UICollectionView.ScrollDirection.vertical
		_flowLayout.minimumInteritemSpacing = 10.0
		_flowLayout.minimumLineSpacing		= 30.0
		_flowLayout.headerReferenceSize 	= CGSize(width: 100, height: 50)
		return _flowLayout
	}
	
	var bigLayout: UICollectionViewFlowLayout {
		let _flowLayout 					= UICollectionViewFlowLayout()
		_flowLayout.itemSize 				= CGSize(width: 300, height: 175)
		_flowLayout.sectionInset 			= UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
		_flowLayout.scrollDirection 		= UICollectionView.ScrollDirection.vertical
		_flowLayout.minimumInteritemSpacing = 10.0
		_flowLayout.minimumLineSpacing		= 30.0
		_flowLayout.headerReferenceSize 	= CGSize(width: 100, height: 50)
		return _flowLayout
	}
	
	let defaults = UserDefaults.standard

	
	// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
		setupMenuButtons()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		cleanTags()
		setupLayout()
	}

	// MARK: - Private Methods
	fileprivate func setupStyle() {
		navigationController?.navigationBar.barStyle = .blackTranslucent
		navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "notQuiteWhite")!]
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "notQuiteWhite")!]
		
		navigationItem.title = "Counters"
	}
	
	fileprivate func setupLayout() {
		if defaults.bool(forKey: "CellLayoutIsBig") {
			countersCollection.collectionView.collectionViewLayout = bigLayout
		} else {
			countersCollection.collectionView.collectionViewLayout = smallLayout
		}
		
		if defaults.bool(forKey: "ViewByTags") {
			viewByTags()
		} else {
			viewByCounters()
		}
	}
	
	fileprivate func setupMenuButtons() {
		struct PlusOneTheme: MenuTheme {
			let font 						= UIFont.systemFont(ofSize: 16, weight: .medium)
			let textColor 					= UIColor(named: "greenPastel")!
			let brightTintColor 			= UIColor.black
			let darkTintColor 				= UIColor.black
			let highlightedTextColor 		= UIColor.white
			let highlightedBackgroundColor 	= UIColor(named: "greenPastel")!
			let backgroundTint 				= UIColor(red:0.18, green:0.77, blue:0.71, alpha: 0.15)
			let gestureBarTint 				= UIColor(named: "greenPastel")!
			let blurEffect 					= UIBlurEffect(style: .dark)
			let shadowColor 				= UIColor.black
			let shadowOpacity				: Float = 0.3
			let shadowRadius				: CGFloat = 7.0
			let separatorColor 				= UIColor(white: 1, alpha: 0.1)
			public init() {}
		}
		
		let viewMenu = MenuView(title: "View", theme: PlusOneTheme()) { () -> [MenuItem] in
			return [
				ShortcutMenuItem(name: "Orginize by Counters", shortcut: nil, action: { [unowned self] in self.viewByCounters() }),
				ShortcutMenuItem(name: "Organize by Tags", shortcut: nil, action: { [unowned self] in self.viewByTags() }),
				SeparatorMenuItem(),
				ShortcutMenuItem(name: "View big cells", shortcut: nil, action: { [unowned self] in self.setBigLayout() }),
				ShortcutMenuItem(name: "View small cells", shortcut: nil, action: { [unowned self] in self.setSmallLayout() }),
				]
		}
		
		let countersMenu = MenuView(title: "Counters", theme: PlusOneTheme()) { () -> [MenuItem] in
			return [
				ShortcutMenuItem(name: "New Counter..", shortcut: ([.command], "N"), action: { [unowned self] in self.addTapped() }),
				SeparatorMenuItem(),
				ShortcutMenuItem(name: "Settings..", shortcut: ([.command], ","), action: { [unowned self] in self.settingsTapped() }),
				]
		}
		
		countersMenu.contentAlignment 	= .left
		viewMenu.contentAlignment		= .center
		
		view.addSubview(viewMenu)
		view.addSubview(countersMenu)
		
		viewMenu.tintColor = UIColor(named: "greenPastel")!
		countersMenu.tintColor = UIColor(named: "greenPastel")!
		
		viewMenu.snp.makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(10)
			make.right.equalTo(countersMenu.snp.leftMargin).offset(-20)
			make.height.equalTo(40)
		}
		
		countersMenu.snp.makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(10)
			make.right.equalTo(self.view.safeAreaLayoutGuide.snp.rightMargin).offset(-10)
			make.height.equalTo(40)
			
		}
	}
	
	fileprivate func cleanTags() {
		let tagsManager 	= countersCollection.dataSource.tagsManager
		let allTags 		= tagsManager.loadFromDefaults()
		var recurrentTags	= [Int]()
		
		for (index, tag) in allTags.enumerated() {
			recurrentTags.append(0)
			for counter in countersCollection.dataSource.countersList {
				if counter.tags.contains(tag) {
					recurrentTags[index] += 1
				}
			}
		}
		
		let indexesOfUnusedTags = recurrentTags.enumerated().filter {
			$0.element == 0
			}.map{$0.offset}
		
		let filteredTagsArray = allTags.enumerated().filter({ !indexesOfUnusedTags.contains($0.0) }).map { $0.1 }

		tagsManager.saveToDefaults(allTags: filteredTagsArray)
	}
	
	
	// UI methods
	@objc func addTapped() {
		let storyboard = UIStoryboard(name: "ThemableAlertVC", bundle: nil)
		let addAlert = storyboard.instantiateViewController(withIdentifier: "ThemableAlertVC") as! ThemableAlertVC
		addAlert.providesPresentationContextTransitionStyle = true
		addAlert.definesPresentationContext = true
		addAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
		addAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
		addAlert.delegate = self
		self.present(addAlert, animated: true, completion: nil)
	}
	
	
	// Counters menu methods
	@objc func settingsTapped() {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "Settings") as? SettingsViewController {
			navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	
	// View menu methods
	@objc func viewByCounters() {
		defaults.set(false, forKey: "ViewByTags")
		countersCollection.dataSource.reorganizeBy(order: .counters)
		countersCollection.collectionView.reloadData()
	}
	
	@objc func viewByTags() {
		defaults.set(true, forKey: "ViewByTags")
		countersCollection.dataSource.reorganizeBy(order: .tags)
		countersCollection.collectionView.reloadData()
	}
	
	@objc func setSmallLayout() {
		UIView.animate(withDuration: 0.3){ [unowned self] in
			self.countersCollection.collectionView.collectionViewLayout = self.smallLayout
		}
		defaults.set(false, forKey: "CellLayoutIsBig")
	}
	
	
	@objc func setBigLayout() {
		UIView.animate(withDuration: 0.3){ [unowned self] in
			self.countersCollection.collectionView.collectionViewLayout = self.bigLayout
		}
		defaults.set(true, forKey: "CellLayoutIsBig")
	}
	
	
}


extension RootViewController: CustomAlertViewDelegate {
	func okButtonTapped(textFieldValue: String) {
		self.countersCollection.dataSource.addCounter(with: textFieldValue)
		self.countersCollection.collectionView.reloadData()
		cleanTags()
		setupLayout()
	}
	
	
	func cancelButtonTapped() {
		//
	}
}
