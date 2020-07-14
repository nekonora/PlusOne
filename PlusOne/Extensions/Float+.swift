//
//  Float+.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 14/07/2020.
//

import Foundation

extension Float {
    
    func stringTruncatingZero() -> String {
        String(format: "%g", self)
    }
}
