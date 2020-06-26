//
//  Counter+CD.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 26/06/2020.
//

import Foundation

extension Counter {
    
    // MARK: - Unwrapped properties
    var uIdentifier: UUID { identifier! }
    var uName: String { name ?? "Invalid name" }
    var uCreatedAt: Date { createdAt ?? Date() }
    var uUpdatedAt: Date { updatedAt ?? Date() }
    var uTags: [Tag] {
        Array(tags as? Set<Tag> ?? Set<Tag>()).sorted(by: { $0.uName > $1.uName })
    }
}
