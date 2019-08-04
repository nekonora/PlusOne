//
//  CounterCellClass.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 04/02/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit
import Menu



/// Protocol conformance to CounterCellDelegate
protocol CounterCellDelegate {
	func didTapStepper(id: UUID, newValue: Float)
	func didTapCustomize(id: UUID)
	func didTapDelete(id: UUID)
	func didTapResetTo(id: UUID)
}


class CounterCell: UICollectionViewCell {
	
	
	// MARK: - UI Outlets
	@IBOutlet weak var smoothView: SmoothView!
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
	
	
	// MARK: - Class Methods
	func setupTheme() {
		TitleLabel.textColor 	= theme.textColor
		CounterLabel.textColor 	= theme.textColor
		unitLabel.textColor 	= theme.textColor
		stepperUI.tintColor		= theme.tintColor
		progressBar.tintColor	= theme.tintColor
		
		smoothView.frame = bounds
		smoothView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
		smoothView.flx_smoothCorners = true
		smoothView.layer.cornerRadius = 15
		
		tagIconImageView.image = tagIconImageView.image?.withRenderingMode(.alwaysTemplate)
		tagIconImageView.tintColor = theme.tagsColor
	}
	
	func setupContextualButton() {
		let contextualMenu = MenuView(title: "...", theme: CustomMenuTheme.dark) { [unowned self] () -> [MenuItem] in
			[ShortcutMenuItem(name: NSLocalizedString("counterMenuCustomize", comment: "Button: customize"), shortcut: nil) { self.selectedCustomize() },
			ShortcutMenuItem(name: NSLocalizedString("counterMenuReset", comment: "Button: reset to"), shortcut: nil) { self.selectedResetTo() },
			SeparatorMenuItem(),
			ShortcutMenuItem(name: NSLocalizedString("counterMenuDelete", comment: "Button: delete"), shortcut: nil) { self.selectedDelete() }]
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

