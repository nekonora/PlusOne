//
//  Mocks.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 08/06/22.
//

import Foundation

enum Mocks {
    
    static let counterSimple: CounterData = CounterData(
        id: UUID(),
        createdAt: Date(),
        modifiedAt: Date(),
        name: "Simple Counter",
        value: 23,
        steps: nil,
        unit: nil,
        completionValue: nil
    )
}
