//
//  DevLogger.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/07/2020.
//

import Foundation

enum LogEventType {
    case coreData(message: String)
}

class DevLogger {
    
    // MARK: - Instance
    static let shared = DevLogger()
    
    // MARK: - Methods
    func logMessage(_ type: LogEventType) {
        var message = "\n[DEV] - "
        switch type {
        case .coreData(let detail): message.append("[CD] - " + detail)
        }
        print(message)
    }
}
