//
//  TagData.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 10/06/22.
//

import Foundation
import CoreData

struct TagData: Identifiable, Hashable {
    let id: UUID
    let name: String
    let color: String
}

extension TagData {
    
    func getCDObject(for context: NSManagedObjectContext) -> Tag {
        let tag = Tag(context: context)
        tag.id = self.id
        tag.name = self.name
        tag.color = self.color
        return tag
    }
}

extension Tag: ThreadSafeable {
    
    func getSafeObject() -> TagData? {
        guard let id = id, let name = name, let color = color
        else {
            return nil
        }
        return TagData(
            id: id,
            name: name,
            color: color
        )
    }
}
