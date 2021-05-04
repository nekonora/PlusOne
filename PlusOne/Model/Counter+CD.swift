//
//  Counter+CD.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 26/06/2020.
//

import Foundation

struct CounterConfig {
    let name: String
    let currentValue: Float
    let increment: Float
    let unit: String?
    let completionValue: Float?
    let createdAt = Date()
    let updatedAt = Date()
    let tags: [Tag] = []
    let group: Group?
}

extension Counter {
    
    // MARK: - Unwrapped properties
    var uTags: [Tag] {
        Array(tags).sorted(by: { $0.name > $1.name })
    }
}
