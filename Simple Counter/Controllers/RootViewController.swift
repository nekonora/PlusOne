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
	@IBOutlet var addCounterView: UIView!
	@IBOutlet var collectionViewContainer: UIView!
	
	
	// MARK: - UIActions
	@IBAction func newCounterCancelTapped(_ sender: Any) {
		UIView.animate(withDuration: 0.3){ [unowned self] in
			self.addCounterView.isHidden 	= true
			self.addCounterView.alpha		= 0
		}
	}
	
	@IBAction func newCounterSaveTapped(_ sender: Any) {
	}
	

	// MARK: - Properties
	var countersCollection: CountersCVC {
		get {
			let ctrl = children.first(where: { $0 is CountersCVC })
			return ctrl as! CountersCVC
		}
	}
	
	var mediumLayout: UICollectionViewFlowLayout {
		let _flowLayout = UICollectionViewFlowLayout()
		_flowLayout.itemSize = CGSize(width: 190, height: 150)
		_flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
		_flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
		_flowLayout.minimumInteritemSpacing = 10.0
		return _flowLayout
	}
	
	var bigLayout: UICollectionViewFlowLayout {
		let _flowLayout = UICollectionViewFlowLayout()
		_flowLayout.itemSize = CGSize(width: 300, height: 150)
		_flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		_flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
		_flowLayout.minimumInteritemSpacing = 10.0
		return _flowLayout
	}

	
	// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
		
		setupMenuButtons()
    }
	

	// MARK: - Private Methods
	fileprivate func setupStyle() {
		navigationController?.navigationBar.barStyle = .blackTranslucent
		navigationController?.navigationBar.barTintColor = UIColor(named: "notQuiteBlack")
		navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "notQuiteWhite")!]
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "notQuiteWhite")!]
		
		navigationItem.title = "My Counters"
		
		addCounterView.isHidden = true
		addCounterView.alpha	= 0.0
	}
	
	fileprivate func setupMenuButtons() {
		struct PlusOneTheme: MenuTheme {
			let font = UIFont.systemFont(ofSize: 16, weight: .medium)
			let textColor = UIColor(named: "greenPastel")!
			let brightTintColor = UIColor.black
			let darkTintColor = UIColor.black
			let highlightedTextColor = UIColor.white
			let highlightedBackgroundColor = UIColor(named: "greenPastel")!
			let backgroundTint = UIColor(red:0.18, green:0.77, blue:0.71, alpha: 0.15)
			let gestureBarTint = UIColor(named: "greenPastel")!
			let blurEffect = UIBlurEffect(style: .dark)
			let shadowColor = UIColor.black
			let shadowOpacity: Float = 0.3
			let shadowRadius: CGFloat = 7.0
			let separatorColor = UIColor(white: 1, alpha: 0.1)
			public init() {}
		}
		
		let viewMenu = MenuView(title: "View", theme: PlusOneTheme()) { () -> [MenuItem] in
			return [
				ShortcutMenuItem(name: "Orginize by Counters", shortcut: nil, action: {}),
				ShortcutMenuItem(name: "Organize by Tags", shortcut: nil, action: {}),
				SeparatorMenuItem(),
				ShortcutMenuItem(name: "View big cells", shortcut: nil, action: { [unowned self] in self.setBigLayout()}),
				ShortcutMenuItem(name: "View medium cells", shortcut: nil, action: { [unowned self] in self.setMediumLayout()}),
				]
		}
		
		let countersMenu = MenuView(title: "Counters", theme: PlusOneTheme()) { () -> [MenuItem] in
			return [
				ShortcutMenuItem(name: "New Counter..", shortcut: ([.command], "N"), action: { [unowned self] in self.addTapped()}),
				SeparatorMenuItem(),
				ShortcutMenuItem(name: "Manage tags", shortcut: ([.command], "T"), action: {}),
				SeparatorMenuItem(),
				ShortcutMenuItem(name: "Settings...", shortcut: ([.command], ","), action: {}),
				]
		}
		
		countersMenu.contentAlignment = .left
		
		view.addSubview(viewMenu)
		view.addSubview(countersMenu)
		
		viewMenu.tintColor = UIColor(named: "greenPastel")!
		countersMenu.tintColor = UIColor(named: "greenPastel")!
		
		viewMenu.snp.makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(10)
			make.left.equalTo(self.view.safeAreaLayoutGuide.snp.leftMargin).offset(10)
			make.height.equalTo(40)
		}
		
		countersMenu.snp.makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(10)
			make.right.equalTo(self.view.safeAreaLayoutGuide.snp.rightMargin).offset(-10)
			make.height.equalTo(40)
		}
		
	}
	
	
	// UI methods
	@objc func addTapped() {
//		UIView.animate(withDuration: 0.3){ [unowned self] in
//			self.addCounterView.isHidden 	= false
//			self.addCounterView.alpha		= 1
//		}
		
		let alert = UIAlertController(title: "Name", message: "Enter a name for the counter", preferredStyle: .alert)


		alert.addTextField { (textField) in
			textField.text = ""
			textField.placeholder = "Counter's name"
			textField.keyboardAppearance = UIKeyboardAppearance.dark
		}

		alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
			let textField 	= alert?.textFields![0]
			self.countersCollection.dataSource.addCounter(with: textField!.text!)

			let indexPath = IndexPath(
				item: 0,
				section: 0
			)

			self.countersCollection.collectionView.performBatchUpdates({
				self.countersCollection.collectionView.insertItems(at: [indexPath])
				self.countersCollection.setupView()
			}, completion: nil)

		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

		self.present(alert, animated: true, completion: nil)
	}
	
	
	@objc func setMediumLayout() {
		UIView.animate(withDuration: 0.3){ [unowned self] in
			self.countersCollection.collectionView.collectionViewLayout = self.mediumLayout
		}
	}
	
	
	@objc func setBigLayout() {
		UIView.animate(withDuration: 0.3){ [unowned self] in
			self.countersCollection.collectionView.collectionViewLayout = self.bigLayout
		}
	}
	
	
}
