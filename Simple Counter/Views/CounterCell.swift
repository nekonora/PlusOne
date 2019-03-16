//
//  CounterCellClass.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 04/02/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit


protocol CounterCellDelegate {
	func didTapStepper(dataSource: CountersDataSource, id: UUID, newValue: Float)
	func didTapEdit(dataSource: CountersDataSource, id: UUID)
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
			let data = cellDelegate.collectionView.dataSource as! CountersDataSource
			feedbackGenerator.impactOccurred()
			feedbackGenerator.prepare()
			cellDelegate.didTapStepper(dataSource: data, id: counterItem.id, newValue: Float(stepperUI.value))
		}
	}
	
	
	@IBAction func editButtonPressed(_ sender: Any) {
		if let cellDelegate = delegate {
			let data = cellDelegate.collectionView.dataSource as! CountersDataSource
			
			cellDelegate.didTapEdit(dataSource: data, id: counterItem.id)
		}
	}
	
	
	// MARK: - Properties
	let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
	var dataSource	: CountersDataSource!
	var counterItem	: CounterV2!
	var delegate	: UICollectionViewController?
	
	
	// MARK: - Lifecycle Methods
	override func awakeFromNib() {
		feedbackGenerator.prepare()
		setupTagsIcon()
	}
	
	
	// MARK: - Private methods
	func setupTagsIcon() {
		tagIconImageView.image = tagIconImageView.image?.withRenderingMode(.alwaysTemplate)
		tagIconImageView.tintColor = UIColor(named: "pastelOrange")!
	}
	
	
}
