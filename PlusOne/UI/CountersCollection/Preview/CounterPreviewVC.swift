//
//  CounterPreviewVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 01/07/2020.
//

import UIKit
import SwiftUI

class CounterPreviewVC: UIHostingController<CounterPreviewView> {
    
    convenience init(counter: Counter) {
        self.init(rootView: CounterPreviewView(counter: counter))
        preferredContentSize = CGSize(width: 300, height: 200)
        view.backgroundColor = UIColor.poBackground3
    }
}
