//
//  CountersDataSource.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 22/02/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit

class CountersDataSource: NSObject, UICollectionViewDataSource {
	
	
	let defaults 			= UserDefaults.standard
	var countersList 		= [CounterStruct]()
	weak var cellDelegate	: UICollectionViewController?
	
	
	override init() {
		super.init()
		
		countersList = loadFromDefaults()
	}
	
	
	// MARK : - UICollectionViewDataSource methods
	
	
	// Number of items in section
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return countersList.count
	}
	
	
	// Cell for item at...
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell 	= collectionView.dequeueReusableCell(withReuseIdentifier: "Counter", for: indexPath) as! CounterCell
		let counter = countersList[indexPath.item]
		
		cell.delegate 				= cellDelegate
		cell.counterItem 			= counter
		cell.TitleLabel.text 		= counter.name
		cell.unitLabel.text			= counter.unit
		cell.stepperUI.stepValue 	= Double(counter.steps)
		
		if counter.completionValue! != 0 {
			let percentage = (counter.value / counter.completionValue)
			cell.progressBar.progress = percentage
		}
		
		cell.CounterLabel.text 	= String(counter.value)
		
		return cell
	}
	
	
	func counter(at index: Int) -> CounterStruct {
		return countersList[index]
	}
	
	
	func loadFromDefaults() -> [CounterStruct] {
		let noCounter = [CounterStruct]()
		if let objects = UserDefaults.standard.value(forKey: "UserCounters") as? Data {
			let decoder = JSONDecoder()
			if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [CounterStruct] {
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
		let newCounter 	= CounterStruct(id: newID,
										name			: name,
										value			: Float(0),
										steps			: Float(1),
										unit			: "",
										completionValue	: Float(0))
		
		countersList.insert(newCounter, at: 0)
		saveToDefaults()
	}
	
	
	func saveToDefaults() {
		let counters = countersList
		
		let encoder = JSONEncoder()
		if let encoded = try? encoder.encode(counters){
			defaults.set(encoded, forKey: "UserCounters")
		}
		print("Data saved")
	}
	
	
}
