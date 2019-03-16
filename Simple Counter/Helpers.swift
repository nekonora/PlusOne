//
//  Helpers.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 03/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import Foundation
import UIKit


class ModelValidator {
	
	
	static func updateModel() {
		
		let defaults = UserDefaults.standard
		
		if let objects = defaults.value(forKey: "UserCounters") as? Data {
			let decoder = JSONDecoder()
			
			if (try? decoder.decode(Array.self, from: objects) as [CounterV2]) != nil {
				
				print("\nModel is up to date\n")
				
			} else if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [CounterStruct] {
				
				var updatedObjectArray = [CounterV2]()
				
				for object in objectsDecoded {
					let updatedObject = CounterV2(
						id: 				object.id,
						name: 				object.name,
						value: 				object.value,
						steps: 				object.steps,
						unit: 				object.unit,
						completionValue: 	object.completionValue,
						
						tags: 				[String]())					// New property
					
					updatedObjectArray.append(updatedObject)
				}
				
				let encoder = JSONEncoder()
				if let encoded = try? encoder.encode(updatedObjectArray){
					defaults.set(encoded, forKey: "UserCounters")
					print("\nModel correctly updated!\n")
				}
			}
		}
		
	}
	
	
}
