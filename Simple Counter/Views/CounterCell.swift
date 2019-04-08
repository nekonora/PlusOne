//
//  CounterCellClass.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 04/02/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit
import Menu


protocol CounterCellDelegate {
	func didTapStepper(id: UUID, newValue: Float)
	func didTapEdit(id: UUID)
	
	func didTapCustomize(id: UUID)
	func didTapDelete(id: UUID)
	func didTapResetTo(id: UUID)
}


class CounterCell: UICollectionViewCell {
	
	
	// MARK: - UI Outlets
	@IBOutlet var TitleLabel	: UILabel!
	@IBOutlet var CounterLabel	: UILabel!
	@IBOutlet var unitLabel		: UILabel!
	@IBOutlet var stepperUI		: UIStepper!
	@IBOutlet var progressBar	: UIProgressView!
	
	@IBOutlet var tagIconImageView: UIImageView!
	@IBOutlet var tagLabel: UILabel!
	

	// MARK: - UI Actions
	@IBAction func stepperChanged(_ sender: Any) {
		if let cellDelegate = delegate {
			feedbackGenerator.impactOccurred()
			feedbackGenerator.prepare()
			cellDelegate.didTapStepper(id: counterItem.id, newValue: Float(stepperUI.value))
		}
	}
	
	
	@IBAction func editButtonPressed(_ sender: Any) {
		if let cellDelegate = delegate {
			
			cellDelegate.didTapEdit(id: counterItem.id)
		}
	}
	
	
	// MARK: - Properties
	let feedbackGenerator 	= UIImpactFeedbackGenerator(style: .light)
	let theme 				= ThemeManager.currentTheme()
	var dataSource			: CountersDataSource!
	var counterItem			: CounterV2!
	var delegate			: RootViewController?
	
	
	// MARK: - Lifecycle Methods
	override func awakeFromNib() {
		feedbackGenerator.prepare()
		setupTheme()
		setupContextualButton()
	}
	
	
	// MARK: - Private methods
	func setupTheme() {
		TitleLabel.textColor 	= theme.textColor
		CounterLabel.textColor 	= theme.textColor
		unitLabel.textColor 	= theme.textColor
		stepperUI.tintColor		= theme.tintColor
		progressBar.tintColor	= theme.tintColor
		
//		backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
		
		let backgroundView = SmoothView()
		backgroundView.frame = bounds
		backgroundView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
		backgroundView.flx_smoothCorners = true
		backgroundView.layer.cornerRadius = 15
		addSubview(backgroundView)
		sendSubviewToBack(backgroundView)
		backgroundView.snp.makeConstraints { (make) -> Void in
			make.width.equalToSuperview()
			make.height.equalToSuperview()
		}
		
		tagIconImageView.image = tagIconImageView.image?.withRenderingMode(.alwaysTemplate)
		tagIconImageView.tintColor = theme.tagsColor
	}
	
	func setupContextualButton() {
	
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
		
		
		let contextualMenu = MenuView(title: "...", theme: PlusOneTheme()) { () -> [MenuItem] in
			return [
				ShortcutMenuItem(name: "Customize..", shortcut: nil, action: { [unowned self] in self.selectedCustomize() }),
				ShortcutMenuItem(name: "Reset to..", shortcut: nil, action: { [unowned self] in self.selectedResetTo() }),
				SeparatorMenuItem(),
				ShortcutMenuItem(name: "Delete", shortcut: nil, action: { [unowned self] in self.selectedDelete() }),
				]
		}
		
		contextualMenu.contentAlignment = .left
		addSubview(contextualMenu)
		contextualMenu.tintColor = theme.tintColor //UIColor(named: "greenPastel")!
		
		contextualMenu.snp.makeConstraints { (make) -> Void in
			make.top.equalToSuperview().offset(10)
			make.right.equalToSuperview().offset(-10)
			make.height.equalTo(30)
			make.width.equalTo(55)
		}
	}
	
	
	// MARK: - Menu Actions
	fileprivate func selectedCustomize() {
		if let cellDelegate = delegate {
			cellDelegate.didTapCustomize(id: counterItem.id)
		}
	}
	
	fileprivate func selectedResetTo() {
		if let cellDelegate = delegate {
			cellDelegate.didTapResetTo(id: counterItem.id)
		}
	}
	
	fileprivate func selectedDelete() {
		if let cellDelegate = delegate {
			cellDelegate.didTapDelete(id: counterItem.id)
		}
	}
	
	
}

