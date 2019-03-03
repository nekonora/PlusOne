//
//  CounterV2.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 03/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import Foundation

class CounterV2 {
	
	var id 				: UUID!
	var name			: String!
	var value			: Float!
	var steps			: Float!
	var unit			: String!
	var completionValue	: Float!
	var tags			: [String]!
	
	init(id: UUID, name: String, value: Float, steps: Float, unit: String, completionValue: Float, tags: [String]) {
		self.id = id
		self.name = name
		self.value = value
		self.steps = steps
		self.unit = unit
		self.completionValue = completionValue
		self.tags = tags
	}
	
}
