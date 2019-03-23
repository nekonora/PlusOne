//
//  CounterClass.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 04/02/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import Foundation


struct CounterStruct: Codable {
	
	var id 				: UUID!
	var name			: String!
	var value			: Float!
	var steps			: Float!
	var unit			: String!
	var completionValue	: Float!
	
}
