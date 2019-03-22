//
//  CountersDataSource.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 22/02/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit
import Menu


class CountersDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	
	// MARK: - Properties
	let defaults 			= UserDefaults.standard
	var countersList 		= [CounterV2]()
	weak var cellDelegate	: UICollectionViewController?
	
	
	// MARK: - Lifecyle Methods
	override init() {
		super.init()
		
		countersList = loadFromDefaults()
	}
	
	
	// MARK: - UICollectionViewDataSource methods
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return countersList.count
	}
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell 	= collectionView.dequeueReusableCell(withReuseIdentifier: "Counter", for: indexPath) as! CounterCell
		let counter = countersList[indexPath.item]
		let tags 	= counter.tags!
		
		cell.delegate 				= cellDelegate
		cell.counterItem 			= counter
		cell.TitleLabel.text 		= counter.name
		cell.unitLabel.text			= counter.unit
		cell.stepperUI.stepValue 	= Double(counter.steps)
		cell.stepperUI.value		= Double(counter.value)
		
		if counter.completionValue! != 0 {
			let percentage = (counter.value / counter.completionValue)
			cell.progressBar.progress = percentage
			cell.progressBar.progressTintColor 	= UIColor(named: "greenPastel")!
		} else {
			cell.progressBar.progress 			= 1.0
			cell.progressBar.progressTintColor 	= UIColor.white.withAlphaComponent(0.1)
			
		}
		
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 2
		formatter.minimumFractionDigits = 0  // or you might use `2` here, too
		formatter.numberStyle = .decimal
		
		if cell.stepperUI.value > 999999 {
			let dividedNumber = cell.stepperUI.value / 1000
			var formattedNumber = formatter.string(from: NSNumber(value: dividedNumber))!
			print(formattedNumber)
			formattedNumber.append("k")
			cell.CounterLabel.text = formattedNumber
		} else {
			cell.CounterLabel.text = formatter.string(from: NSNumber(value: counter.value))
		}
		
		
		// Default values
		cell.tagLabel.textColor = UIColor(named: "pastelOrange")!
		
		switch tags.count {
		case 0:
			cell.tagLabel.isHidden 			= false
			cell.tagIconImageView.isHidden 	= true
			
			cell.tagLabel.text				= "No tags"
			cell.tagLabel.textColor			= UIColor.white.withAlphaComponent(0.3)
		case 1:
			cell.tagLabel.isHidden 			= false
			cell.tagIconImageView.isHidden 	= false
			
			cell.tagLabel.text 				= tags.first
			cell.tagIconImageView.image 	= UIImage(named: "tag")!
			cell.setupTagsIcon()
		default:
			cell.tagLabel.isHidden 			= false
			cell.tagIconImageView.isHidden 	= false
			
			cell.tagLabel.text 				= "\(tags.count) tags"
			cell.tagIconImageView.image 	= UIImage(named: "multipleTags")!
			cell.setupTagsIcon()
		}
		
		return cell
	}
	
	
	// MARK: - UICollectionViewDelegateFlowLayout Methods
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		
		let totalCellWidth = 300 * collectionView.numberOfItems(inSection: 0)
		let totalSpacingWidth = 10 * (collectionView.numberOfItems(inSection: 0) - 1)
		
		let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
		let rightInset = leftInset
		
		return UIEdgeInsets(top: 10, left: leftInset, bottom: 10, right: rightInset)
	}
	
	
	// MARK: - Private Methods
	func counter(at index: Int) -> CounterV2 {
		return countersList[index]
	}
	
	
	func loadFromDefaults() -> [CounterV2] {
		let noCounter = [CounterV2]()
		if let objects = UserDefaults.standard.value(forKey: "UserCountersV2") as? Data {
			let decoder = JSONDecoder()
			if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [CounterV2] {
				return objectsDecoded
			} else {
				return noCounter
			}
		} else {
			return noCounter
		}
	}
	
	
	func addCounter(with name: String) {
		let newID = UUID()
		let newCounter 	= CounterV2(id				: newID,
									name			: name,
									value			: Float(0),
									steps			: Float(1),
									unit			: "",
									completionValue	: Float(0),
									tags			: [String]())
		
		countersList.insert(newCounter, at: 0)
		saveToDefaults()
	}
	
	
	func saveToDefaults() {
		let counters = countersList
		
		let encoder = JSONEncoder()
		if let encoded = try? encoder.encode(counters){
			defaults.set(encoded, forKey: "UserCountersV2")
		}
	}
	
	
}
