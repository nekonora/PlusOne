//
//  Preferences.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 09/06/22.
//

import Foundation
import DefaultsWrapper

extension Preferences {
    
    struct App {
        
        enum Keys: String, CaseIterable {
            case oldModelDefaults = "UserCounters"
        }
        
        // MARK: - Properties
        @OptionalStorage<Data>(key: Keys.oldModelDefaults.rawValue)
        static var oldModelDefaults: Data?
        
        // MARK: - Utilities
        static func resetKeys(for keys: Set<Keys>) {
            let defaults = UserDefaults.standard
            keys.forEach {
                defaults.set(nil, forKey: $0.rawValue)
                defaults.synchronize()
            }
        }
        
        static func reset() {
            resetKeys(for: Set(Keys.allCases))
        }
    }
}
