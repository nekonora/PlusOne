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
	
	
	// UI Outlets
	@IBOutlet var TitleLabel	: UILabel!
	@IBOutlet var CounterLabel	: UILabel!
	@IBOutlet var unitLabel		: UILabel!
	@IBOutlet var stepperUI		: UIStepper!
	@IBOutlet var progressBar	: UIProgressView!
	
	
	// Methods
	
	@IBAction func stepperChanged(_ sender: Any) {
		if let cellDelegate = delegate {
			let data = cellDelegate.collectionView.dataSource as! CountersDataSource
			
			cellDelegate.didTapStepper(dataSource: data, id: counterItem.id, newValue: Float(stepperUI.value))
		}
	}
	
	
	@IBAction func editButtonPressed(_ sender: Any) {
		if let cellDelegate = delegate {
			let data = cellDelegate.collectionView.dataSource as! CountersDataSource
			
			cellDelegate.didTapEdit(dataSource: data, id: counterItem.id)
		}
	}
	
	
	// Properties
	var dataSource	: CountersDataSource!
	var counterItem	: CounterStruct!
	var delegate	: UICollectionViewController?
	
	
}
