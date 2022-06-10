//
//  Numeric+.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 08/06/22.
//

import Foundation

extension Numeric {
    
    var nilIfZero: Self? {
        if self == 0 {
            return nil
        } else {
            return self
        }
    }
}
