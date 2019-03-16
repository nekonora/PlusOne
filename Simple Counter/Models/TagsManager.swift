//
//  TagsDataSource.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 04/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


class TagsManager {
	
	
	// MARK: - Properties
	let defaults 	= UserDefaults.standard
	
	
	// MARK: - Private methods
	func addTag(named: String) {
		var allTags = loadFromDefaults()
		allTags.insert(named, at: 0)
		saveToDefaults(allTags: allTags)
	}
	
	
	func removeTag(named: String) {
		var allTags = loadFromDefaults()
		if allTags.contains(named) {
			let index = allTags.firstIndex(of: named)!
			allTags.remove(at: index)
			saveToDefaults(allTags: allTags)
		}
	}
	
	
	func saveToDefaults(allTags: [String]) {
		let encoder = JSONEncoder()
		if let encoded = try? encoder.encode(allTags){
			defaults.set(encoded, forKey: "UserTags")
		}
	}
	
	
	func loadFromDefaults() -> [String] {
		let noTags = [String]()
		if let objects = UserDefaults.standard.value(forKey: "UserTags") as? Data {
			let decoder = JSONDecoder()
			if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [String] {
				return objectsDecoded
			} else {
				return noTags
			}
		} else {
			return noTags
		}
	}

	
}
