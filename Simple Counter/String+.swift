//
//  String+.swift
//  Simple Counter
//
//  Created by Filippo Zaffoni on 01/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import Foundation


extension String {
	
	
	static let numberFormatter = NumberFormatter()
	
	
	var floatValue: Float {
		
		String.numberFormatter.decimalSeparator = "."
		
		if let result =  String.numberFormatter.number(from: self) {
			return result.floatValue
		} else {
			String.numberFormatter.decimalSeparator = ","
			if let result = String.numberFormatter.number(from: self) {
				return result.floatValue
			}
		}
		return 0
		
	}
	
	
}
