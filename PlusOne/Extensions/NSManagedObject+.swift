//
//  NSManagedObject+.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 27/06/2020.
//

import CoreData
import Foundation

extension NSManagedObject {
    
    static var typeName: String { String(describing: self) }
}
