//
//  CountersDataSource.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 22/02/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit
import Menu


enum orderBy {
	case counters
	case tags
}


class CountersDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	
	// MARK: - Properties
	let defaults 			= UserDefaults.standard
	var countersList 		= [CounterV2]()
	var tagsManager 		= TagsManager()
	var tagsList 			= [String]()
	var grouping 			= orderBy.counters
	var tagsGroupedCounters = [[Int]]()				// [indexes of counters where the tag is]
	weak var cellDelegate	: RootViewController?
	
	
	// MARK: - Lifecyle Methods
	override init() {
		super.init()
		countersList 	= loadFromDefaults()
		tagsList 		= tagsManager.loadFromDefaults()
	}
	
	
	// MARK: - UICollectionViewDataSource methods
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		switch grouping {
		case .counters:
			return 1
		case .tags:
			return tagsGroupedCounters.count
		}
	}
	
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		switch grouping {
		case .counters:
			let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "tagHeader", for: indexPath) as! TagHeaderView
			header.titleLabel.text = "\(countersList.count) " + NSLocalizedString("rootControllerCollection_byCountersTitle", comment: "counters")
			return header
		case .tags:
			let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "tagHeader", for: indexPath) as! TagHeaderView
			header.titleLabel.text = tagsList[indexPath.section]
			return header
		}
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch grouping {
		case .counters:
			return countersList.count
		case .tags:
			let numberOfCountersByTag = tagsGroupedCounters[section].count
			return numberOfCountersByTag
		}
		
	}
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell 	= collectionView.dequeueReusableCell(withReuseIdentifier: "Counter", for: indexPath) as! CounterCell
		
		let counter : CounterV2
		let tags 	: [String]
		
		switch grouping {
		case .counters:
			counter 			= countersList[indexPath.item]
			tags 				= counter.tags!
		case .tags:
			let indexes 		= tagsGroupedCounters[indexPath.section]
			let counterIndex	= indexes[indexPath.item]
			counter				= countersList[counterIndex]
			tags 				= counter.tags!
		}
		
		cell.delegate 				= cellDelegate
		cell.counterItem 			= counter
		cell.TitleLabel.text 		= counter.name
		cell.unitLabel.text			= counter.unit
		
		if counter.steps == 0 {
			cell.stepperUI.stepValue 	= Double(1)
		} else {
			cell.stepperUI.stepValue 	= Double(counter.steps)
		}
		
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
			
			cell.tagLabel.text				= NSLocalizedString("rootControllerCollection_noTagsTitle", comment: "No tags")
			cell.tagLabel.textColor			= UIColor.white.withAlphaComponent(0.3)
		case 1:
			cell.tagLabel.isHidden 			= false
			cell.tagIconImageView.isHidden 	= false
			
			cell.tagLabel.text 				= tags.first
			cell.tagIconImageView.image 	= UIImage(named: "tag")!
			cell.setupTheme()
		default:
			cell.tagLabel.isHidden 			= false
			cell.tagIconImageView.isHidden 	= false
			
			cell.tagLabel.text 				= "\(tags.count) " + NSLocalizedString("rootControllerCollection_tagsNumber", comment: "..tags")
			cell.tagIconImageView.image 	= UIImage(named: "multipleTags")!
			cell.setupTheme()
		}
		
		return cell
	}
	
	
	// MARK: - UICollectionViewDelegateFlowLayout Methods
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		
		let totalCellWidth 		= 300 * collectionView.numberOfItems(inSection: 0)
		let totalSpacingWidth 	= 10 * (collectionView.numberOfItems(inSection: 0) - 1)
		
		let leftInset 			= (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
		let rightInset 			= leftInset
		
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
	
	func removeAllCounters() {
		countersList.removeAll(keepingCapacity: false)
		saveToDefaults()
	}
	
	func saveToDefaults() {
		let counters = countersList
		
		let encoder = JSONEncoder()
		if let encoded = try? encoder.encode(counters){
			defaults.set(encoded, forKey: "UserCountersV2")
		}
	}
	
	
	func reorganizeBy(order: orderBy) {
		switch order {
		case .counters:
			grouping = .counters
		case .tags:
			grouping = .tags
			tagsGroupedCounters = arrayOfTags()
		}
	}
	
	
	fileprivate func arrayOfTags() -> [[Int]] {
		tagsList 			= tagsManager.loadFromDefaults()
		var countersByTags 	= [[String]]()
		var arrayByTags		= [[Int]]()
		if let index 		= tagsList.firstIndex(of: NSLocalizedString("rootControllerCollection_noTagsTitle", comment: "No tags")) { tagsList.remove(at: index) }
		
		for counter in countersList {
			countersByTags.append(counter.tags)
		}
		
		for tag in tagsList {
			let indexes = countersByTags.enumerated().filter {
				$0.element.contains(tag)
				}.map{$0.offset}
			arrayByTags.append(indexes)
		}
		
		let indexesOfNoTag 	= countersByTags.enumerated().filter {
			$0.element.isEmpty
			}.map{$0.offset}
		
		if !indexesOfNoTag.isEmpty {
			if !tagsList.contains(NSLocalizedString("rootControllerCollection_noTagsTitle", comment: "No tags")) { tagsList.append(NSLocalizedString("rootControllerCollection_noTagsTitle", comment: "No tags")) }
			arrayByTags.append(indexesOfNoTag)
		}
		
		return arrayByTags
	}
	
	
}
