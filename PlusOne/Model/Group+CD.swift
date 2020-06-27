//
//  Group+CD.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 26/06/2020.
//

import Foundation

extension Group {
    
    // MARK: - Unwrapped properties
    var uCounters: [Counter] {
        Array(counters as? Set<Counter> ?? Set<Counter>()).sorted(by: { $0.updatedAt > $1.updatedAt })
    }
}
