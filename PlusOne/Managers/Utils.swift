//
//  Utils.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 27/07/2020.
//

import Foundation

class Utils {
    
    // MARK: - Properties
    private let formatter = DateFormatter()
    
    // MARK: - Instance
    static let shared = Utils()
    
    // MARK: - Methods
    func formatDateToShort(_ date: Date) -> String {
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
