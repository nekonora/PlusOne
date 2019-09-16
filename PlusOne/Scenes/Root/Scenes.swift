//
//  Scenes.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 16/09/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit

/// Provides instantiation methods for UI elements
enum Scenes {
    
    case countersList
//    case tagsList
//    case settings
    
    /// Creates a new VC from a storyboard
    func fromStoryboard() -> UIViewController? {
        switch self {
        case .countersList: return storyboard.instantiateInitialViewController()
//        case .tagsList:
//        case .settings:
        }
    }
    
    private var storyboard: UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
    
    private var name: String {
        switch self {
        case .countersList: return "CountersList"
        }
    }
}
