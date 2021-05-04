//
//  Rswift+.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 04/05/21.
//

import Rswift
import SwiftUI

extension FontResource {
    func font(size: CGFloat) -> Font {
        Font.custom(fontName, size: size)
    }
}

extension ColorResource {
    var color: Color {
        Color(name)
    }
}

extension StringResource {
    var localizedStringKey: LocalizedStringKey {
        LocalizedStringKey(key)
    }
    
    var text: Text {
        Text(localizedStringKey)
    }
}

extension ImageResource {
    var image: Image {
        Image(name)
    }
}
