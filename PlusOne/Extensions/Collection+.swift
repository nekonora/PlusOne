//
//  Collection+.swift
//  PlayTrack
//
//  Created by Filippo Zaffoni on 09/02/2020.
//  Copyright © 2020 Filippo Zaffoni. All rights reserved.
//

import Foundation

extension Collection {
    
    var hasSomething: Bool { !self.isEmpty }
    
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
