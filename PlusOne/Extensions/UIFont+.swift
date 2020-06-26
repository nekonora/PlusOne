//
//  UIFont+.swift
//  PlayTrack
//
//  Created by Filippo Zaffoni on 10/02/2020.
//  Copyright © 2020 Filippo Zaffoni. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func roundedFont(ofSize style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        let fontSize = UIFont.preferredFont(forTextStyle: style).pointSize
        if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: fontSize)
        } else {
            return UIFont.preferredFont(forTextStyle: style)
        }
    }
}
