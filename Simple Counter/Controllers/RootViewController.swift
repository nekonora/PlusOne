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
	@IBOutlet var titleLabel: UILabel!
	

	// MARK: - Properties
	let theme 				= ThemeManager.currentTheme()
	var countersCollection	: CountersCVC {
		get {
			let ctrl = children.first(where: { $0 is CountersCVC })
			return ctrl as! CountersCVC
		}
	}
	
	let defaults = UserDefaults.standard

	
	// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
		
		countersCollection.dataSource.cellDelegate = self
		setupMenuButtons()
		setupTheme()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
		reloadView()
	}
	

	// MARK: - Private Methods
	func reloadView() {
		cleanTags()
		setupLayout()
		setupTheme()
		countersCollection.setupView()
	}
	
	fileprivate func setupLayout() {
		let userChooseSmallLayout 	= defaults.bool(forKey: "CellLayoutIsSmall")
		let userChooseViewByTags 	= defaults.bool(forKey: "ViewByTags")
		
		_ = userChooseViewByTags ? viewByTags() : viewByCounters()
		if userChooseSmallLayout {
			countersCollection.collectionView.collectionViewLayout = CountersLayoutType.small
		} else {
			countersCollection.collectionView.collectionViewLayout = CountersLayoutType.big
		}
	}
	
	fileprivate func setupTheme() {
		view.backgroundColor = theme.backgroundColor
		
		titleLabel.textColor 	= theme.textColor
		
		switch UIDevice.modelName {
		case "iPhone 5s", "iPhone SE", "Simulator iPhone 5s", "Simulator iPhone SE":
			titleLabel.text	= NSLocalizedString("rootControllerTitle_oldDevices", comment: "Plus1")
		default:
			titleLabel.text	= NSLocalizedString("rootControllerTitle_newDevices", comment: "Counters")
		}

		navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
	}
	
	fileprivate func setupMenuButtons() {
		let viewMenu = MenuView(title: NSLocalizedString("rootViewMenu_title", comment: "Title: View menu"), theme: CustomMenuTheme.dark) { [unowned self] () -> [MenuItem] in
			[ShortcutMenuItem(name: NSLocalizedString("rootViewMenu_organizeByCounters", comment: "Action: organize counters by counters"), shortcut: nil) { self.viewByCounters() },
			ShortcutMenuItem(name: NSLocalizedString("rootViewMenu_organizeByTags", comment: "Action: organize counters by tags"), shortcut: nil) { self.viewByTags() },
			SeparatorMenuItem(),
			ShortcutMenuItem(name: NSLocalizedString("rootViewMenu_viewBigCells", comment: "Action: view big cells"), shortcut: nil) { self.setBigLayout() },
			ShortcutMenuItem(name: NSLocalizedString("rootViewMenu_viewSmallCells", comment: "Action: view small cells"), shortcut: nil) { self.setSmallLayout() }]
		}
		
		let countersMenu = MenuView(title: NSLocalizedString("rootCountersMenu_title", comment: "Title: Counters menu"), theme: CustomMenuTheme.dark) { [unowned self] () -> [MenuItem] in
			[ShortcutMenuItem(name: NSLocalizedString("rootCountersMenu_newCounter", comment: "Action: new counter"), shortcut: ([.command], "N")){ self.addTapped() },
			ShortcutMenuItem(name: NSLocalizedString("rootCountersMenu_deleteAll", comment: "Action: delete all counters"), shortcut: nil){ self.deleteAllTapped() },
			SeparatorMenuItem(),
			ShortcutMenuItem(name: NSLocalizedString("rootCountersMenu_goToSettings", comment: "Action: go to settings screen"), shortcut: ([.command], ",")){ self.settingsTapped() }]
		}
		
		viewMenu.contentAlignment		= .center
		countersMenu.contentAlignment 	= .left
		
		view.addSubview(viewMenu)
		view.addSubview(countersMenu)
		
		viewMenu.tintColor = theme.tintColor
		countersMenu.tintColor = theme.tintColor
		
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
		addAlert.definesPresentationContext 				= true
		addAlert.modalPresentationStyle 					= UIModalPresentationStyle.overCurrentContext
		addAlert.modalTransitionStyle 						= UIModalTransitionStyle.crossDissolve
		addAlert.delegate = self
		
		addAlert.alertTitle 		= NSLocalizedString("rootAlertAddCounter_title", comment: "Title: add counter")
		addAlert.alertDescription 	= NSLocalizedString("rootAlertAddCounter_description", comment: "Description: write the name of the counter")
		addAlert.alertOkButtonText 	= NSLocalizedString("rootAlertAddCounter_addButton", comment: "Button: Add")
		addAlert.alertKeyboardType 	= .default
		addAlert.alertPlaceholder 	= NSLocalizedString("rootAlertAddCounter_placeholder", comment: "Placeholder: Name")
		addAlert.alertAction		= .addCounter
		
		self.present(addAlert, animated: true, completion: nil)
	}
	
	@objc func deleteAllTapped() {
		let storyboard = UIStoryboard(name: "ThemableAlertVC", bundle: nil)
		let deleteAllAlert = storyboard.instantiateViewController(withIdentifier: "ThemableAlertVC") as! ThemableAlertVC
		deleteAllAlert.providesPresentationContextTransitionStyle 	= true
		deleteAllAlert.definesPresentationContext 					= true
		deleteAllAlert.modalPresentationStyle 						= UIModalPresentationStyle.overCurrentContext
		deleteAllAlert.modalTransitionStyle 						= UIModalTransitionStyle.crossDissolve
		deleteAllAlert.delegate = self
		
		deleteAllAlert.alertTitle 			= NSLocalizedString("rootAlertDeleteAll_title", comment: "Title: Delete all")
		deleteAllAlert.alertDescription 	= NSLocalizedString("rootAlertAddCounter_description", comment: "Title: do you really want to delete all counters?")
		deleteAllAlert.alertOkButtonText 	= NSLocalizedString("rootAlertAddCounter_deleteButton", comment: "Button: delete")
		deleteAllAlert.alertAction			= .deleteAll
		
		self.present(deleteAllAlert, animated: true, completion: nil)
	}
	
	
	// Counters menu methods
	@objc func addCounter(name: String) {
		countersCollection.dataSource.addCounter(with: name)
		reloadView()
		countersCollection.collectionView.reloadData()
	}
	
	@objc func deleteAllCounters() {
		countersCollection.dataSource.removeAllCounters()
		reloadView()
		countersCollection.collectionView.reloadData()
	}
	
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
			self.countersCollection.collectionView.collectionViewLayout = CountersLayoutType.small
		}
		defaults.set(true, forKey: "CellLayoutIsSmall")
	}
	
	
	@objc func setBigLayout() {
		UIView.animate(withDuration: 0.3){ [unowned self] in
			self.countersCollection.collectionView.collectionViewLayout = CountersLayoutType.big
		}
		defaults.set(false, forKey: "CellLayoutIsSmall")
	}
	
}


extension RootViewController: CustomAlertViewDelegate {
	func okButtonTapped(counterID: UUID?, alertType: alertType, textFieldValue: String) {
		switch alertType {
		case .addCounter:
			addCounter(name: textFieldValue)
		case .resetCounter:
			guard counterID != nil else { return }
			let newValue = (textFieldValue as NSString).floatValue
			resetCounter(id: counterID!, value: newValue)
		case .deleteCounter:
			guard counterID != nil else { return }
			deleteCounter(id: counterID!)
		case .deleteAll:
			deleteAllCounters()
		}
	}
	
	func cancelButtonTapped() {}
}
