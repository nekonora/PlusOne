//
//  Collection+.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 08/06/22.
//

import Foundation

extension Collection {
    
    var nilIfEmpty: Self? {
        if isEmpty {
            return nil
        } else {
            return self
        }
    }
}
