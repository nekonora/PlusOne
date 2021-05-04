//
//  Tag+CD.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 26/06/2020.
//

import Foundation

extension Tag {
    
    // MARK: - Unwrapped properties
    var uCounters: [Counter] {
        Array(counters as? Set<Counter> ?? Set<Counter>()).sorted(by: { $0.updatedAt > $1.updatedAt })
    }
}

extension Tag: Comparable {
    
    public static func < (lhs: Tag, rhs: Tag) -> Bool {
        lhs.name < rhs.name
    }
}
