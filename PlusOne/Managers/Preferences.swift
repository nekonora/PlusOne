//
//  Preferences.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 26/06/2020.
//

import Foundation

class Preferences {
    
    // MARK: - Keys
    enum PreferenceKey: String {
        case selectedSectionID
    }
    
    // MARK: - Properties
    @Stored<String>(.selectedSectionID)
    static var selectedSectionID: String?
    
    // MARK: - Methods
    static func removeData(for keys: Set<PreferenceKey>) {
        if keys.contains(.selectedSectionID) { selectedSectionID = nil }
    }
}

@propertyWrapper struct Stored<T: Codable> {
    
    let key: Preferences.PreferenceKey
    let defaultValue: T?
    
    init(_ key: Preferences.PreferenceKey, defaultValue: T? = nil) {
        self.key          = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            guard let data = UserDefaults.standard.object(forKey: key.rawValue) as? Data else { return defaultValue }
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}
